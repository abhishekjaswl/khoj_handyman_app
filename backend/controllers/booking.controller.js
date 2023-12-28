const UserModel = require("../models/user.model");
const WorkerModel = require("../models/worker.model");


exports.verifiedWorkerList = async (req, res, next) => {
    try {
        const workers = await UserModel.find({ role: "worker", status: "verified" });
        const workersDetails = await WorkerModel.find({});

        const workerList = workers.map(user => {
            const workerDetails = workersDetails.find(worker => worker._id.equals(user._id));
            return {
                ...user.toObject(),
                ...(workerDetails ? workerDetails.toObject() : {}),
            };
        });

        res.status(200).json(workerList);
    } catch (error) {
        return next(error);
    }
}

exports.postBookingRequest = async (req, res, next) => {
    try {
        const { userId, workerId, dateTime } = req.body;

        const worker = await WorkerModel.findOne({ _id: workerId });

        if (!worker) {
            return next('Worker not found!');
        }

        worker.bookingRequests.push({
            userId,
            dateTime
        });

        const bookingDetails = await worker.save();
        const latestBooking = bookingDetails.bookingRequests[bookingDetails.bookingRequests.length - 1];
        res.status(200).json(latestBooking);
    } catch (error) {
        return next(error);
    }
}