//
//
// import 'package:base_lib/tools/log/log_manager.dart';
//
// const int PAGE_COUNT_SIZE = 15;
// const int CURRENT_PAGE = 1;
//
// abstract class IBasePageView<T> {
//   void refreshCompleted();
//   void loadMoreCompleted();
//   void emptyPage();
//   void setData(List<T> data,bool isRefreshLast);
//   void lastData();
//   void moreLoadFail(Exception exception);
//   void onLoadFail(Exception exception);
// }
//
// typedef DataListener<T> = Function(int currentPage,int pageSize);
//
// class RefreshCenter<T>{
//
//   ///下拉刷新或第一次刷新
//   bool isRefreshLast = true;
//
//   ///开始
//   int _currentPage = CURRENT_PAGE;
//
//   ///页数
//   final int _pageSize;
//
//   final DataListener _dataListener;
//
//   IBasePageView<T>? iPageBaseView;
//
//
//   RefreshCenter(DataListener dataListener,{int? pageSize}):_dataListener = dataListener,
//   _pageSize = pageSize??PAGE_COUNT_SIZE;
//
//   void makeCurrentPage() {
//     _currentPage++;
//     LogManager.log.d("当前$_currentPage");
//     isRefreshLast = false;
//   }
//
//   ///刷新
//   void refreshData() {
//     isRefreshLast = true;
//     _currentPage = CURRENT_PAGE;
//     _dataListener.call( _currentPage,_pageSize);
//   }
//
//   ///刷新已经加载的数据
//   void refreshLoadData(){
//     isRefreshLast = true;
//     ULog.d("当前$_currentPage总共${_pageSize*_currentPage}");
//     _dataListener.call(CURRENT_PAGE,_pageSize*(_currentPage--));
//   }
//
//   ///加载
//   void loadMore() {
//     isRefreshLast = false;
//     _dataListener.call( _currentPage,_pageSize);
//   }
//
//   void dataError(Error error) {
//     iPageBaseView?.loadMoreCompleted();
//     iPageBaseView?.refreshCompleted();
//     if (isRefreshLast) {
//       iPageBaseView?.onLoadFail(error.exception);
//     } else {
//       ULog.i("loading finish");
//       iPageBaseView?.moreLoadFail(error.exception);
//     }
//   }
//
//   void dataSucces(List<T>? data, int total) {
//     iPageBaseView?.loadMoreCompleted();
//     iPageBaseView?.refreshCompleted();
//     if (total == 0) {
//       if (isRefreshLast) {
//         iPageBaseView?.setData([], isRefreshLast);
//         iPageBaseView?.emptyPage();
//       }
//     } else {
//       if (data == null || data.isEmpty) {
//         if (isRefreshLast) {
//           iPageBaseView?.setData([], isRefreshLast);
//           iPageBaseView?.emptyPage();
//         }
//       } else {
//         ULog.i("page$_currentPage,total$total");
//         iPageBaseView?.setData(data, isRefreshLast);
//         if (_pageSize * _currentPage >= total) {
//           ULog.i("loading finish");
//           iPageBaseView?.lastData();
//         }
//         makeCurrentPage();
//       }
//     }
//   }
//
// }