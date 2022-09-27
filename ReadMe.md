# Test Swile

## Features:
- Display transactions list
- Display transactions detail
- Infinite pagination  
- Off line mode
- Transactions list to detail transition animate
- Transaction detail to list transition animate
- FR and EN languages are supported

## Architecture:

The architecture I have chosen is MVVM Coordinator, I have tried to use dependency injection 
and OOP (Object Oriented Programming) as much as possible.

I have also tried to separate responsibilities, for example:
- APIService provides only API call
- RequestFactory generates API Request 
- TransactionManager parses raw data into Transaction models.

I have also created a separate class to handle the UITableView (delegate, datasource, register cell, style)

In addition I've used factories to limit the coupling between Coordinator and ViewControllers, 
and also between sceneDelegate and app Coordinator.

ViewControllers and Coordinator don't communicate.
ViewModels communicates with the Coordinator through the viewModel delegate property.

Coordinator will instantiate a ViewModel, get the corresponding viewController by calling the corresponding ViewControllerFactory method, then set itself as viewModel delegate, and present the viewController.

The Coordinator never knows the concrete type of the viewController, and the viewController never knows the concrete type of the viewModel and has no reference to the Coordinator.

Regarding the viewModels viewController binding, I have used Combine CurrentValueSubject.

For all asynchronous work i have used Apple Concurrency API async await.

I've also create a tiny design system component, 
the SWKit which contain color, icons, custom button and label.

## Difficulties:

The main difficulty was the transition from list to detail and the inverse transition animation.
I have done it by using UIViewControllerAnimatedTransitioning and UIViewControllerTransitioningDelegate.

For the animation i have use the animation Key frame API (UIView.animateKeyframes)

So i was able to adjust all differents animations sequences.

For the infinite scroll, i insert a batch of new section (and transactions) 
when the user see the last transaction cell.

## Tools / Dependencies / Unit testings:

- I use SnapKit for setup view layouting
- I have done unit testings for viewModels, TransactionManager (Model parser), RequestFactory, ArchiverManager, ImageDownloader, and APIService
- I have set up a Swiftlint build phase so if Swiftlint were installed, it would run.
