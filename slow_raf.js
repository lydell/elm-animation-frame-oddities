{
    let queue = {};
    let pending = false;
    let uid = 0;

    window.cancelAnimationFrame = function (id)
    {
        delete queue[id];
    }

    window.requestAnimationFrame = function (callback)
    {
        let id = uid;
        uid++;
        queue[id] = callback;
        if (!pending)
        {
            pending = true;
            setTimeout(function () {
                pending = false;
                let maxId = uid;
                for (let id2 in queue)
                {
                    if (id2 >= maxId)
                    {
                        break;
                    }
                    let callback = queue[id2];
                    delete queue[id2];
                    callback();
                }
            }, 1000 - Date.now() % 1000);
        }
        return id;
    }
}
