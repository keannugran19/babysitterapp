import 'package:babysitterapp/models/search_result.dart';
import 'package:babysitterapp/pages/search_page/pages/user_details_page.dart';
import 'package:flutter/material.dart';
import 'package:babysitterapp/styles/colors.dart';
import 'package:babysitterapp/styles/size.dart';

class SearchResultsWidget extends StatelessWidget {
  final List<SearchResult> searchResults;
  final Function(SearchResult) onLabelClick;
  final bool noResultsFound;
  final String type;

  const SearchResultsWidget({
    super.key,
    required this.searchResults,
    required this.onLabelClick,
    required this.noResultsFound,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(sizeConfig.widthSize(context) * 0.05),
      child: Column(
        children: [
          if (noResultsFound)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'No results found',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final result = searchResults[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                    color: const Color(0xFFF1F1F1),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(result.profileImage),
                      ),
                      title: Text(result.name, style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: textColor)
                      ),
                      subtitle: Text(result.bio),
                      trailing: Text('${result.rating} ★ (${result.reviewsCount} reviews)'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserDetailsPage(babysitter: result),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
