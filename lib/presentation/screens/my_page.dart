import 'package:cfq/domain/entities/user_entity.dart';
import 'package:cfq/presentation/themes/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cfq/presentation/bloc/user_cubit.dart';
import 'package:cfq/presentation/bloc/user_state.dart';
import 'package:cfq/presentation/screens/rm_page.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Page'),
      ),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error.isNotEmpty) {
            return Center(child: Text('Error: ${state.error}'));
          }

          final user = state.user;
          if (user == null) {
            return const Center(child: Text('No user data'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        // const SizedBox(height: 8),
                        // Text(
                        //   'Phone: ${user.phoneNumber}',
                        //   style: Theme.of(context).textTheme.titleMedium,
                        // ),
                        Spacer(),
                        const SizedBox(height: 8),
                        Card(
                          color: AppColor.mint,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${_formatRole(user.role)}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                FlutterCarousel(
                  options: FlutterCarouselOptions(
                    height: 200.0,
                    showIndicator: true,
                    slideIndicator: CircularSlideIndicator(
                      slideIndicatorOptions: SlideIndicatorOptions(
                        /// The alignment of the indicator.
                        alignment: Alignment.bottomCenter,
                        currentIndicatorColor: AppColor.mint,
                      ),
                    ),
                  ),
                  items: [
                    CarouselItem(
                      imagePath:
                          'https://cafe.naver.com/common/storyphoto/viewer.html?src=https%3A%2F%2Fcafeptthumb-phinf.pstatic.net%2FMjAyNTAyMDJfMTcg%2FMDAxNzM4NDY2NzQxMDE1.O3AR2IUwhgNK1CuHIioQ8viiyE5vJ2KCbpvfH3oHVgsg.aoxsifoXUZvYt2SfKs_vSAwMPsJj1G0xRwyNvOcokyUg.JPEG%2FIMG_8055.JPG%3Ftype%3Dw1600',
                      isNetworkImage: true,
                    ),
                    CarouselItem(
                      imagePath:
                          'https://cafe.naver.com/common/storyphoto/viewer.html?src=https%3A%2F%2Fcafeptthumb-phinf.pstatic.net%2FMjAyNDA5MTNfOTAg%2FMDAxNzI2MjAwNjE4NTY4.oFtGHMa0jHp1H_n7AgiMAHPE3xd7GJ5RVmiu7FEWNcog.3Br1Y8gEBLK3wMFYAK9Q_-pMqGSdWFmwiF5T1okQOjQg.JPEG%2FKakaoTalk_20240913_125101878.jpg%3Ftype%3Dw1600',
                      isNetworkImage: true,
                    ),
                    CarouselItem(
                      imagePath:
                          'https://cafe.naver.com/common/storyphoto/viewer.html?src=https%3A%2F%2Fcafeptthumb-phinf.pstatic.net%2FMjAyNDA3MzBfMzgg%2FMDAxNzIyMzE2MDQyNTYw.-cynDtyK84Ri2pIAIQeKl90zJ0d719c7wWhgy8jfLdMg.TgoZrz5oL7FQS5n0inubPd46nCPpyoAgEjY8dcsRJrUg.JPEG%2FIMG_4323.JPG%3Ftype%3Dw1600',
                      isNetworkImage: true,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/rm');
                    },
                    icon: const Icon(Icons.fitness_center),
                    label: const Text('View RM Records'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatRole(UserRole role) {
    // enum 값을 사용자 친화적인 텍스트로 변환
    final name = role.toString().split('.').last;
    // 첫 글자만 대문자로 변환
    return name[0].toUpperCase() + name.substring(1).toLowerCase();
  }
}

class CarouselItem extends StatelessWidget {
  final String imagePath;
  final bool isNetworkImage;

  const CarouselItem({
    Key? key,
    required this.imagePath,
    this.isNetworkImage = false,
  }) : super(key: key);

  static String parseNaverCafeImageUrl(String originalUrl) {
    try {
      if (originalUrl
          .contains('cafe.naver.com/common/storyphoto/viewer.html')) {
        final uri = Uri.parse(originalUrl);
        final srcParam = uri.queryParameters['src'];

        if (srcParam != null) {
          final decodedUrl = Uri.decodeFull(srcParam);
          return decodedUrl.split('?type=')[0];
        }
      }
      return originalUrl;
    } catch (e) {
      print('Error parsing Naver Cafe image URL: $e');
      return originalUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    final processedImagePath = parseNaverCafeImageUrl(imagePath);

    return GestureDetector(
      onTap: () => _showFullScreenImage(context, processedImagePath),
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        child: isNetworkImage
            ? Image.network(
                processedImagePath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              )
            : Image.asset(
                processedImagePath,
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, String processedImagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero, // 전체 화면을 위해 패딩 제거
          child: Stack(
            fit: StackFit.expand, // 전체 화면 확장
            children: [
              InteractiveViewer(
                // 확대/축소 가능하게 만들기
                child: isNetworkImage
                    ? Image.network(
                        processedImagePath,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      )
                    : Image.asset(
                        processedImagePath,
                        fit: BoxFit.contain,
                      ),
              ),
              Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
