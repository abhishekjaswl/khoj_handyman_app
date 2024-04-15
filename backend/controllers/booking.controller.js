const UserModel = require("../models/user.model");
const WorkerModel = require("../models/worker.model");
const AuthService = require("../services/auth.service");

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
        const { userId, workerId, dateTime, message } = req.body;
        const worker = await WorkerModel.findOne({ _id: workerId });
        if (!worker) {
            return next('Worker not found!');
        }
        worker.bookingRequests.push({
            userId,
            dateTime,
            message
        });
        const bookingDetails = await worker.save();
        const latestBooking = bookingDetails.bookingRequests[bookingDetails.bookingRequests.length - 1];

        const user = await UserModel.findOne({ _id: workerId });

        res.status(200).json({ ...latestBooking.toObject(), user: user.toObject() });
    } catch (error) {
        return next(error);
    }
}

exports.updateBookingRequest = async (req, res, next) => {
    try {
        const id = req.params.id;
        const action = req.params.status;
        const worker = await WorkerModel.findOne({ 'bookingRequests._id': id });

        if (!worker) {
            return next('Booking request not found');
        }
        const booking = worker.bookingRequests.find(booking => booking._id.toString() === id);

        if (action == 'accept') {
            worker.currentBooking.push(booking);
            await worker.save();
        } else {
            worker.bookingHistory.push(booking);
            await worker.save();
        }

        const user = await UserModel.findOne({ _id: booking.userId });
        const email = user.email;
        const userName = `${user.firstName} ${user.lastName}`;

        const message = `Your booking request has been ${action}ed. Please check your app for details. \n\ Booking Id : ${booking._id}`

        await AuthService.sendEmail(email, userName, message, null, 'Your booking details.', res, next);

        await WorkerModel.findByIdAndUpdate(
            { '_id': worker._id },
            { $pull: { bookingRequests: { _id: id } } },
            { new: true }
        );

        res.status(200).json(`Booking ${action}ed`);
    } catch (error) {
        return next(error);
    }
}

exports.updateCurrentBooking = async (req, res, next) => {
    try {
        const id = req.params.id;
        const action = req.params.status;
        const worker = await WorkerModel.findOne({ 'currentBooking._id': id });

        if (!worker) {
            return next('Booking request not found');
        }
        const booking = worker.currentBooking.find(booking => booking._id.toString() === id);

        worker.bookingHistory.push(booking);
        await worker.save();

        const user = await UserModel.findOne({ _id: booking.userId });
        const email = user.email;
        const userName = `${user.firstName} ${user.lastName}`;

        const message = `Your booking request has been ${action}ed. Please check your app for details. \n\ Booking Id : ${booking._id}`

        await AuthService.sendEmail(email, userName, message, null, 'Your booking details.', res, next);

        await WorkerModel.findByIdAndUpdate(
            { '_id': worker._id },
            { $pull: { currentBooking: { _id: id } } },
            { new: true }
        );

        res.status(200).json(`Booking ${action}ed`);
    } catch (error) {
        return next(error);
    }
}

exports.getBookingRequests = async (req, res, next) => {
    try {
        const id = req.params.id;
        const workers = await WorkerModel.findOne({ _id: id });

        if (!workers) {
            return next('Worker not found.');
        }
        const bookingRequests = workers.bookingRequests;
        const bookingDetails = await Promise.all(
            bookingRequests.map(async booking => {
                const user = await UserModel.findOne({ _id: booking.userId });
                return {
                    ...booking.toObject(), user: user.toObject()
                };
            })
        );

        res.status(200).json(bookingDetails);
    } catch (error) {
        return next(error);
    }
}

exports.getBookingHistory = async (req, res, next) => {
    try {
        const id = req.params.id;
        const workers = await WorkerModel.findOne({ _id: id });

        if (!workers) {
            return next('Worker not found.');
        }
        const bookingHistory = workers.bookingHistory;
        const bookingDetails = await Promise.all(
            bookingHistory.map(async booking => {
                const user = await UserModel.findOne({ _id: booking.userId });
                return {
                    ...booking.toObject(), user: user.toObject()
                };
            })
        );

        res.status(200).json(bookingDetails);
    } catch (error) {
        return next(error);
    }
}

exports.getCurrentBookings = async (req, res, next) => {
    try {
        const id = req.params.id;
        const workers = await WorkerModel.findOne({ _id: id });

        if (!workers) {
            return next('Worker not found.');
        }
        const currentBooking = workers.currentBooking;
        const bookingDetails = await Promise.all(
            currentBooking.map(async booking => {
                const user = await UserModel.findOne({ _id: booking.userId });
                return {
                    ...booking.toObject(), user: user.toObject()
                };
            })
        );

        res.status(200).json(bookingDetails);
    } catch (error) {
        return next(error);
    }
}


exports.getUserBookReq = async (req, res, next) => {
    try {
        const userId = req.params.uid;

        const workers = await WorkerModel.find({ 'bookingRequests.userId': userId });

        if (!workers) {
            return next('Worker not found with the provided userId in bookingRequests');
        }

        const bookingRequest = [];
        // Iterate through each worker to get their details
        for (const worker of workers) {
            // Filter bookingRequests to include only the requests with the provided userId
            const bookingRequests = worker.bookingRequests.filter(request => request.userId === userId);
            // Find the user details using the userId from one of the booking requests
            const user = await UserModel.findOne({ _id: worker._id });
            if (!user) {
                return next('User not found for the booking requests');
            }

            const workerInfo = {
                job: worker.job,
                availability: worker.availability,
                paymentQrUrl: worker.paymentQrUrl,
                ...user.toObject()
            };

            for (const bookingReq of bookingRequests) {
                bookingRequest.push({ user: workerInfo, ...bookingReq.toObject() });
            }
        }
        res.status(200).json(bookingRequest);
    } catch (error) {
        throw error;
    }
}

exports.getUserBookHistory = async (req, res, next) => {
    try {
        const userId = req.params.uid;

        const workers = await WorkerModel.find({ 'bookingHistory.userId': userId });

        if (!workers) {
            return next('Worker not found with the provided userId in bookingRequests');
        }

        const bookingHistory = [];
        // Iterate through each worker to get their details
        for (const worker of workers) {
            // Filter bookingRequests to include only the requests with the provided userId
            const bookingHistorys = worker.bookingHistory.filter(request => request.userId === userId);
            // Find the user details using the userId from one of the booking requests
            const user = await UserModel.findOne({ _id: worker._id });
            if (!user) {
                return next('User not found for the booking requests');
            }

            const workerInfo = {
                job: worker.job,
                availability: worker.availability,
                paymentQrUrl: worker.paymentQrUrl,
                ...user.toObject()
            };

            for (const bookingHis of bookingHistorys) {
                bookingHistory.push({ user: workerInfo, ...bookingHis.toObject() });
            }
        }
        res.status(200).json(bookingHistory);
    } catch (error) {
        throw error;
    }
}
