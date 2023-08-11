import 'package:flutter/material.dart';
import 'package:meu_flash/models/dailystats_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meu_flash/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meu_flash/stores/selected_decks.dart';
import 'package:provider/provider.dart';

class CategoryHeader extends StatefulWidget {
  final Map<String, Set<String>> categories;
  final GlobalKey headerKey;
  final DailyStatsModel dailyStatsModel;
  final UserModel user;

  static const double circleAvatarRadius = 30;
  static const double circleAvatarPadding = 8.0;

  CategoryHeader({
    required this.categories,
    required this.headerKey,
    required this.dailyStatsModel,
    required this.user,
  });

  @override
  _CategoryHeaderState createState() => _CategoryHeaderState();
}

class _CategoryHeaderState extends State<CategoryHeader> {
  Set<String> selectedCategories = {'category1', 'category2'};

  @override
  Widget build(BuildContext context) {
    double totalWidth = (widget.categories.length + 1) * (2 * CategoryHeader.circleAvatarPadding + 2 * CategoryHeader.circleAvatarRadius);
    double padding = totalWidth > MediaQuery.of(context).size.width
        ? 0
        : (MediaQuery.of(context).size.width - totalWidth) / 2;

    return Container(
      height: 60 + 2 * CategoryHeader.circleAvatarPadding + 2 * CategoryHeader.circleAvatarRadius,
      child: Stack(
        children: [
          Positioned(
            top: 8,
            left: (MediaQuery.of(context).size.width - 120) / 2,
            child: Image.asset(
              'lib/assets/logo/text_logo.png',
              width: 120,
              height: 60,
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: Icon(
              Icons.home,
              color: Colors.white,
              size: 28,
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Row(
              children: [
                Image.asset(
                  'lib/assets/simbolos/foguinho.png',
                  height: 28,
                ),
                SizedBox(width: 2),
                Text(
                  '${widget.dailyStatsModel.streak}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 15),
                Image.asset(
                  'lib/assets/simbolos/xp.png',
                  height: 45,
                ),
                SizedBox(width: 2),
                Text(
                  '${widget.dailyStatsModel.xpDia}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 65,
            left: padding,
            right: padding,
            child: Container(
              height: 2 * CategoryHeader.circleAvatarRadius + 2 * CategoryHeader.circleAvatarPadding,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                itemCount: widget.categories.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.all(CategoryHeader.circleAvatarPadding),
                      child: CircleAvatar(
                        radius: CategoryHeader.circleAvatarRadius,
                        backgroundImage: _buildProfileImage(),
                      ),
                    );
                  }

                  final category = widget.categories.keys.elementAt(index - 1);
                  return Padding(
                    padding: const EdgeInsets.all(CategoryHeader.circleAvatarPadding),
                    child: InkWell(
                      onTap: () {
                        SelectedDecks selectedDecks = Provider.of<SelectedDecks>(context, listen: false);
                        if (selectedCategories.contains(category)) {
                          selectedDecks.removeDecksFromCategory(widget.categories[category] ?? {});
                          setState(() {
                            selectedCategories.remove(category);
                          });
                        } else {
                          selectedDecks.addDecksFromCategory(widget.categories[category] ?? {});
                          setState(() {
                            selectedCategories.add(category);
                          });
                        }
                      },
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: CategoryHeader.circleAvatarRadius,
                            backgroundImage: AssetImage(
                              'lib/assets/${category.toLowerCase()}.jpg',
                            ),
                          ),
                          if (selectedCategories.contains(category))
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          if (selectedCategories.isEmpty)
            Positioned(
              top: 65,
              left: 8 + CategoryHeader.circleAvatarPadding + CategoryHeader.circleAvatarRadius,
              child: CircleAvatar(
                radius: CategoryHeader.circleAvatarRadius,
                backgroundColor: Colors.transparent,
              ),
            ),
        ],
      ),
    );
  }

  ImageProvider _buildProfileImage() {
    if (widget.user.profilePicture != null && widget.user.profilePicture is String) {
      return NetworkImage(widget.user.profilePicture);
    } else if (widget.user.profilePicture != null && widget.user.profilePicture is String) {
      return AssetImage(widget.user.profilePicture);
    } else {
      return AssetImage('lib/assets/profile_picture.png');
    }
  }
}
