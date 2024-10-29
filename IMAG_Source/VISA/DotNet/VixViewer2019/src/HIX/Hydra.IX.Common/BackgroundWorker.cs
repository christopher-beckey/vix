using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Diagnostics;
using System.Threading;
using System.Threading.Tasks;

namespace Hydra.IX.Common
{
    public class BackgroundWorker<T>
    {
        private BlockingCollection<T> _JobQueue = new BlockingCollection<T>();
        private CancellationTokenSource cancellationTokenSource = null;
        private Task[] tasks;
        private int _maxThreads = 10;
        private object syncObject = new object();
        private Action<T, int, int, CancellationToken> _actionDelegate;
        private Action<int> _initDelegate;
        private long _pendingJobCount = 0;

        public BackgroundWorker(int maxThreads, Action<T, int, int, CancellationToken> actionDelegate, Action<int> initDelegate = null)
        {
            _maxThreads = maxThreads;
            _actionDelegate = actionDelegate;
            _initDelegate = initDelegate;
        }

        public void Start(bool waitUntilInit = false)
        {
            Stop();

            lock (syncObject)
            {
                cancellationTokenSource = new CancellationTokenSource();
                var token = cancellationTokenSource.Token;
                int runningThreadCount = 0;
                ManualResetEvent intializedEvent = new ManualResetEvent(false);

                tasks = new Task[_maxThreads];
                for (int i = 0; i < _maxThreads; i++)
                {
                    tasks[i] = Task.Factory.StartNew(() =>
                    {
                        int threadId = Thread.CurrentThread.ManagedThreadId;
                        int threadIndex = i;
                        Debug.WriteLine("Background Worker started {0}", threadId);
                        if (_initDelegate != null)
                            _initDelegate(threadId);

                        if (Interlocked.Increment(ref runningThreadCount) == _maxThreads)
                        {
                            intializedEvent.Set();
                        }

                        bool jobAvailable = false;
                        do
                        {
                            T jobData;
                            Debug.WriteLine("Background Worker {0} - Waiting for job...", threadId);
                            jobAvailable = _JobQueue.TryTake(out jobData, Timeout.Infinite);
                            if (jobAvailable)
                            {
                                try
                                {
                                    Debug.WriteLine("Background Worker {0} - Executing job...", threadId);
                                    _actionDelegate(jobData, threadId, threadIndex, token);

                                    Interlocked.Decrement(ref _pendingJobCount);
                                }
                                catch (Exception ex)
                                {
                                    Debug.Write(ex.ToString());
                                }
                            }
                            else
                            {
                                Debug.WriteLine("Background Worker {0} - No job found. Exiting...", threadId);
                            }
                        } while (jobAvailable);

                        //foreach (var jobData in _JobQueue.GetConsumingEnumerable())
                        //{
                        //    if (token.IsCancellationRequested)
                        //        break;

                        //    try
                        //    {
                        //        _actionDelegate(jobData, threadId, token);
                        //    }
                        //    catch (Exception)
                        //    { }
                        //}
                    });
                }

                if (waitUntilInit)
                {
                    intializedEvent.WaitOne();
                }
            }
        }

        public void Stop()
        {
            lock (syncObject)
            {
                if (cancellationTokenSource != null)
                {
                    cancellationTokenSource.Cancel();
                    _JobQueue.CompleteAdding();

                    if (tasks != null)
                    {
                        Task.WaitAll(tasks);
                        tasks = null;
                    }
                }
            }
        }

        public void Wait()
        {
            lock (syncObject)
            {
                if (_JobQueue != null)
                {
                    _JobQueue.CompleteAdding();

                    if (tasks != null)
                    {
                        Task.WaitAll(tasks);
                        tasks = null;
                    }
                }
            }
        }

        public void WaitUntilEmpty(int intervalMilliseconds)
        {
            // Note: no locking for now
            while (true)
            {
                // exit if queue is shutting down
                if (_JobQueue.IsAddingCompleted)
                    break;

                // exit if all jobs executed
                if (Interlocked.Read(ref _pendingJobCount) == 0)
                    break;

                Thread.Sleep(intervalMilliseconds);
            }
        }

        public void QueueJob(T jobData)
        {
            Interlocked.Increment(ref _pendingJobCount);

            _JobQueue.Add(jobData);
        }

        public bool IsIdle
        {
            get
            {
                return (Interlocked.Read(ref _pendingJobCount) == 0);
            }
        }

        public static void Execute(Action<T, int, int, CancellationToken> actionDelegate,
                                   IEnumerable<T> jobList,
                                   int threadCount,
                                   bool maximizeThreadUsage = false)
        {
            BackgroundWorker<T> taskQueue = new BackgroundWorker<T>(threadCount, actionDelegate);
            taskQueue.Start(maximizeThreadUsage);

            foreach (var job in jobList)
            {
                taskQueue.QueueJob(job);
            }
            taskQueue.Wait();
        }
    }
}