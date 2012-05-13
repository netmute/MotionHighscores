class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    tabbar = UITabBarController.alloc.init

    tabbar.viewControllers = [
      JSONTableViewController.alloc.initWithHighscore('Easy'),
      JSONTableViewController.alloc.initWithHighscore('Medium'),
      JSONTableViewController.alloc.initWithHighscore('Hard')
    ]

    tabbar.selectedIndex = 0
    tabbar.title = 'Highscores'

    @window.rootViewController = UINavigationController.alloc.initWithRootViewController(tabbar)
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible
    true
  end
end
