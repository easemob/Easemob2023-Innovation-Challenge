export default class RequestUtil {
  constructor(baseURL) {
    this.baseURL = baseURL;
  }

  get(url, data) {
    return this.request('GET', url, data);
  }

  post(url, data) {
    return this.request('POST', url, data);
  }

  request(method, url, data) {
    return new Promise((resolve, reject) => {
      uni.request({
        url: this.baseURL + url,
        method: method,
        data: data,
        success: (res) => {
          resolve(res.data);
        },
        fail: (err) => {
          reject(new Error(err.errMsg));
        },
      });
    });
  }
}
