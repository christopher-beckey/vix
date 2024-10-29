using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace Hydra.IX.Common
{
    public class TaskGroup<T>
    {
        private BlockingCollection<T> _JobQueue = new BlockingCollection<T>();
        private CancellationTokenSource _LinkedTokenSource = new CancellationTokenSource();
        private CancellationTokenSource _InternalTokenSource = new CancellationTokenSource();
        private Task[] tasks;
        private int _maxThreads = 10;
        private Action<T, CancellationToken> _actionDelegate;
        private IEnumerable<T> _JobList = null;

        private TaskGroup(IEnumerable<T> jobList, 
                          int maxThreads, 
                          CancellationToken externalToken, 
                          Action<T, CancellationToken> actionDelegate)
        {
            _maxThreads = maxThreads;
            _JobList = jobList;
            _actionDelegate = actionDelegate;
            _LinkedTokenSource = CancellationTokenSource.CreateLinkedTokenSource(_InternalTokenSource.Token, externalToken);
        }

        private void Start()
        {
            tasks = new Task[_maxThreads];
            for (int i = 0; i < _maxThreads; i++)
            {
                tasks[i] = Task.Factory.StartNew(() =>
                {
                    bool jobAvailable = false;
                    do
                    {
                        T jobData;
                        jobAvailable = _JobQueue.TryTake(out jobData, Timeout.Infinite);

                        if (jobAvailable)
                        {
                            try
                            {
                                _actionDelegate(jobData, _LinkedTokenSource.Token);
                            }
                            catch (Exception ex)
                            {
                            }
                        }

                        if (_LinkedTokenSource.IsCancellationRequested)
                            break;
                    } 
                    while (jobAvailable);
                });
            }

            // add jobs to job queue
            foreach (var job in _JobList)
                _JobQueue.Add(job);

            _JobQueue.CompleteAdding();
        }

        public static TaskGroup<T> StartNew(IEnumerable<T> jobList, 
                                         int maxThreads, 
                                         CancellationToken externalToken, 
                                         Action<T, CancellationToken> actionDelegate)
        {
            var taskGroup = new TaskGroup<T>(jobList, maxThreads, externalToken, actionDelegate);
            
            taskGroup.Start();

            return taskGroup;
        }

        public void Wait()
        {
            if (tasks != null)
            {
                Task.WaitAll(tasks);
                tasks = null;
            }
        }
    }
}
