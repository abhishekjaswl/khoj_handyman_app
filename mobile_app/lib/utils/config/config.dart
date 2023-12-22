// open cmd and enter ipconfig to get localhost ip

const url = 'http://192.168.0.103:4000/api/';

const login = "${url}auth/login";
const register = "${url}auth/register";
const checkEmailApi = "${url}auth/checkEmail";
const getRegisOTP = "${url}auth/getRegisOTP";
const allUsersApi = "${url}user/allUsers";
const uploadProfilePicApi = "${url}user/uploadProfilePic";
const uploadKYCApi = "${url}user/uploadKYCApi";
const verWorkerList = "${url}booking/verWorkerList";
const verifyOTPApi = "${url}auth/verifyOTP";
