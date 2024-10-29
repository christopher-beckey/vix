/**
 * WorkerQueue.js
 * Class to handle long-running, asynchronous tasks.
 */
var WorkerQueue = function(workerFile, notifyBgTaskCallback) {
    this.imageUid = [];
    this.queue = [];
    this.taskDispatcher = null;
    this.worker = new Worker(workerFile);
    this.notifyBgTask = notifyBgTaskCallback;
    this.stop = false;
}

WorkerQueue.prototype.pop = function () {
    if (!this.taskDispatcher) {
        if (this.queue.length > 0 && !this.stop) {
            this.taskDispatcher = this.queue.shift();
        }
    }

    if (this.taskDispatcher != null) {
        this.taskDispatcher();
    } else if(this.notifyBgTask != null) {
        this.notifyBgTask();
    }
};

WorkerQueue.prototype.push = function (task) {
    this.queue.push(task);
    if (this.queue.length == 1) {
        this.pop();
    }
};

WorkerQueue.prototype.remove = function (_imageUid) {
    this.taskDispatcher = null;
    if (_imageUid && this.imageUid[_imageUid]) {
        this.imageUid[_imageUid] = null;
    }
    this.pop();
};

WorkerQueue.prototype.reset = function () {
    this.taskDispatcher = null;
    this.queue = [];
    this.imageUid = [];
    this.stop = false;
};

WorkerQueue.prototype.pause = function () {
    this.stop = true;
};

WorkerQueue.prototype.resume = function () {
    this.stop = false;
    this.pop();
};

WorkerQueue.prototype.shiftTask = function () {
    return this.queue.shift();
};