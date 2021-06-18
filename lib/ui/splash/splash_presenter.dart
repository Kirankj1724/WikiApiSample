import 'package:wiki_api_sample/ui/splash/splash_view.dart';

class SplashPresenter{

  SplashView? _view;

  SplashPresenter(SplashView view)
  {
    this._view=view;
  }

  void doSplashLoading() {
    if(_view!=null)
      {
        _view!.doStartTimerAction();
      }
  }


}