import '../model/onboarding_model.dart';

class OnboardingViewModel {
  List<OnboardingModel> getPages() {
    return [
      OnboardingModel(
        title: "Bring Your Vision to Life",
        body: "Plan and manage events seamlessly with our easy-to-use tools.",
        imagePath: 'asset/images/onboard_1.png',
      ),
      OnboardingModel(
        title: "Create Events That Inspire!",
        body: "Host memorable events that captivate and engage your audience.",
        imagePath: 'asset/images/onboard_2.png',
      ),
      OnboardingModel(
        title: "Your Event, Your Way!",
        body: "From start to finish, we help bring your event ideas to reality.",
        imagePath: 'asset/images/onboard_3.png',
      ),
    ];
  }
}
