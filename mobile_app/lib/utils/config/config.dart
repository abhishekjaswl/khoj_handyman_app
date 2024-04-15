// open cmd and enter ipconfig to get localhost ip

const url = 'http://192.168.0.102:4000/api/';

const login = "${url}auth/login";
const register = "${url}auth/register";
const checkEmailApi = "${url}auth/checkEmail";
const getRegisOTP = "${url}auth/getRegisOTP";
const verifyOTPApi = "${url}auth/verifyOTP";

const uploadPictureApi = "${url}user/uploadPicture";
const uploadKYCApi = "${url}user/uploadKYC";
const updateAvailability = "${url}user/updateAvailability";

const verWorkerList = "${url}booking/verWorkerList";
const postBookingRequest = "${url}booking/postBookingRequest";
const getBookingRequestsApi = "${url}booking/getBookingRequests";
const getBookingRequestsWorkApi = "${url}booking/getBookingHistory";
const getCurrentBookingsApi = "${url}booking/getCurrentBookings";
const getUserBookingHistoryApi = "${url}booking/getUserBookHistory";
const getWorkerBookingHistoryApi = "${url}booking/getBookingHistory";
const updateBookingRequestApi = "${url}booking/updateBookingRequest";
const updateCurrentBookingApi = "${url}booking/updateCurrentBooking";
const getBookingsList = "${url}booking/getUserBookReq";

const allUsers = "${url}admin/allUsers";
const userList = "${url}admin/userList";
const workerList = "${url}admin/workerList";
const pendingList = "${url}admin/pendingList";
const updateStatus = "${url}admin/updateStatus";
