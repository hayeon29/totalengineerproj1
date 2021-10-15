class IconMenu {
  final String title;
  final String subtitle;

  IconMenu({required this.title, required this.subtitle});
}

final List<IconMenu> iconMenu = [
  IconMenu(title: '개인정보 설정', subtitle: '사용자의 개인 정보를 설정합니다.'),
  IconMenu(title: '테마 설정', subtitle: '앱 테마를 설정합니다.'),
  IconMenu(title: '알림 설정', subtitle: '알림 받을 상황, 알림의 종류등을 설정합니다.'),
  IconMenu(title: '개인정보처리방침', subtitle: ''),
  IconMenu(title: '라이센스', subtitle: ''),
];

