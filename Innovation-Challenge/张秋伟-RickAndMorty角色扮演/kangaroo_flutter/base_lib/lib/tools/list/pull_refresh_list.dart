


import 'package:base_lib/base_lib.dart';

typedef RequestData = void Function(int currentPage ,int pageSize);

class PullRefreshList{

  static const PAGE_COUNT_SIZE = 15;
  static const CURRENT_PAGE = 1;

  bool _isRefreshLast = true;
  ///开始
  int _currentPage;
  ///页数
  int _pageSize;
  RequestData _requestData;

  PullRefreshListener _pullRefreshListener;

  PullRefreshList(this._requestData,this._pullRefreshListener,{int? currentPage = CURRENT_PAGE,int? pageSize =PAGE_COUNT_SIZE}):_currentPage = CURRENT_PAGE,_pageSize = PAGE_COUNT_SIZE;


  void _makeCurrentPage() {
    _currentPage++;
    LogManager.log.d("当前 ${_currentPage}");
    _isRefreshLast = false;
  }

  ///刷新
  void refreshData() {
    _isRefreshLast = true;
    _currentPage = 1;
    _requestData(_currentPage,_pageSize);
  }

  ///刷新已经加载的数据
  void refreshLoadData(){
    _isRefreshLast = true;
    LogManager.log.d("当前$_currentPage 总共 $_pageSize*$_currentPage");
    _requestData(1,_pageSize*(_currentPage--));
  }

  ///加载
  void loadMore() {
    _isRefreshLast = false;
    _requestData(_currentPage,_pageSize);
  }


  void dataError(Error error) {
    _pullRefreshListener.loadMoreCompleted();
    _pullRefreshListener.refreshCompleted();
    if (_isRefreshLast) {
      _pullRefreshListener.onLoadFail(error.exception);
    } else {
      _pullRefreshListener.moreLoadFail(error.exception);
    }
  }



  void dataSucces(List? data, int total) {
    _pullRefreshListener.loadMoreCompleted();
    _pullRefreshListener.refreshCompleted();
    if (total == 0) {
      if (_isRefreshLast) {
        _pullRefreshListener.setData([], _isRefreshLast);
        _pullRefreshListener.emptyPage();
      }
    } else {
      if (data == null || data.isEmpty) {
        if (_isRefreshLast) {
          _pullRefreshListener.setData([], _isRefreshLast);
          _pullRefreshListener.emptyPage();
        }
      } else {
        LogManager.log.i("page$_currentPage,total$total");
        _pullRefreshListener.setData(data, _isRefreshLast);
      if (_pageSize * _currentPage >= total) {
        _pullRefreshListener.lastData();
      }
        _makeCurrentPage();
      }
    }
  }


}


abstract class PullRefreshListener {
  void refreshCompleted();
  void loadMoreCompleted();
  void emptyPage();
  void setData(List data, bool isRefreshLast);
  void lastData();
  void moreLoadFail(Exception exception);
  void onLoadFail(Exception exception);
}