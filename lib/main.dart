
import 'package:flutter/material.dart';

void main() {
  runApp(const CineMovieApp());
}

const Color bgColor = Color(0xFF101014);
const Color cardColor = Color(0xFF1C1C24);
const Color accentColor = Color(0xFFE50914);

class CineMovieApp extends StatelessWidget {
  const CineMovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CineMovie',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        colorScheme: const ColorScheme.dark(
          primary: accentColor,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class SearchMovieContent extends StatefulWidget {
  final List<Map<String, String>> movies;
  final Function(Map<String, String>) onMovieTap;

  const SearchMovieContent({
    super.key,
    required this.movies,
    required this.onMovieTap,
  });

  @override
  State<SearchMovieContent> createState() =>
      _SearchMovieContentState();
}

class _SearchMovieContentState
    extends State<SearchMovieContent> {
  final TextEditingController searchController =
      TextEditingController();

  String keyword = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = widget.movies.where((movie) {
      return movie['title']!
          .toLowerCase()
          .contains(keyword.toLowerCase());
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Search Movies',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: searchController,
            onChanged: (value) {
              setState(() {
                keyword = value;
              });
            },
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search movie title...',
              hintStyle:
                  const TextStyle(color: Colors.white54),
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.white54,
              ),
              filled: true,
              fillColor: cardColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: keyword.isEmpty
                ? const Center(
                    child: Text(
                      'Search your favorite movies',
                      style: TextStyle(color: Colors.white54),
                    ),
                  )
                : results.isEmpty
                    ? const Center(
                        child: Text(
                          'Movie not found',
                          style: TextStyle(color: Colors.white54),
                        ),
                      )
                    : ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final movie = results[index];

                       return ListTile(
  onTap: () {
    FocusScope.of(context).unfocus();
    widget.onMovieTap(movie);
  },
  contentPadding: const EdgeInsets.symmetric(vertical: 8),
  leading: Image.network(
    movie['image']!,
    width: 50,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) {
      return const Icon(Icons.movie, color: Colors.white);
    },
  ),
  title: Text(
    movie['title']!,
    style: const TextStyle(color: Colors.white),
  ),
  subtitle: Text(
    'Rating: ${movie['rating']}',
    style: const TextStyle(color: Colors.white70),
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

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  List<Map<String, String>> favoriteMovies = [];
  void toggleFavorite(Map<String, String> movie) {
  setState(() {
    bool isFavorite = favoriteMovies.any(
      (item) => item['title'] == movie['title'],
    );

    if (isFavorite) {
      favoriteMovies.removeWhere(
        (item) => item['title'] == movie['title'],
      );
    } else {
      favoriteMovies.add(movie);
    }
  });
}

void addMovie() {
  final titleController = TextEditingController();
  final ratingController = TextEditingController();
  final imageController = TextEditingController();

  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: cardColor,
        title: const Text(
          'Tambah Film',
          style: TextStyle(color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Judul Film',
                ),
              ),
              TextField(
                controller: ratingController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Rating',
                ),
              ),
              TextField(
                controller: imageController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'URL Poster Film',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
            ),
            onPressed: () {
              if (titleController.text.trim().isEmpty ||
                  ratingController.text.trim().isEmpty ||
                  imageController.text.trim().isEmpty) {
                return;
              }

              setState(() {
                popularMovies.add({
                  'title': titleController.text.trim(),
                  'rating': ratingController.text.trim(),
                  'image': imageController.text.trim(),
                });
              });

              Navigator.pop(dialogContext);
            },
            child: const Text(
              'Tambah',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}
void showMovieDetail(Map<String, String> movie) {
  showModalBottomSheet(
    context: context,
    backgroundColor: cardColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  movie['image']!,
                  height: 220,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              movie['title']!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '⭐ Rating: ${movie['rating']}',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                ),
                onPressed: () {
                  toggleFavorite(movie);
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.favorite,
                  color: Colors.white,
                ),
                label: const Text(
                  'Tambah / Hapus Favorite',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
  final List<Map<String, String>> trendingMovies = [
    {
      'title': 'Interstellar',
      'rating': '8.7',
      'image':
          'https://image.tmdb.org/t/p/w500/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg',
    },
    {
      'title': 'Inception',
      'rating': '8.8',
      'image':
          'https://image.tmdb.org/t/p/w500/oYuLEt3zVCKq57qu2F8dT7NIa6f.jpg',
    },
    {
      'title': 'The Batman',
      'rating': '7.8',
      'image':
          'https://image.tmdb.org/t/p/w500/74xTEgt7R36Fpooo50r9T25onhq.jpg',
    },
    {
      'title': 'Avatar',
      'rating': '7.9',
      'image':
          'https://image.tmdb.org/t/p/w500/kyeqWdyUXW608qlYkRqosgbbJyK.jpg',
    },
  ];

  final List<Map<String, String>> popularMovies = [
    {
      'title': 'Joker',
      'rating': '8.2',
      'image':
          'https://image.tmdb.org/t/p/w500/udDclJoHjfjb8Ekgsd4FDteOkCU.jpg',
    },
    {
      'title': 'Dune',
      'rating': '8.0',
      'image':
          'https://image.tmdb.org/t/p/w500/d5NXSklXo0qyIYkgV94XAgMIckC.jpg',
    },
    {
      'title': 'Avengers',
      'rating': '8.4',
      'image':
          'https://image.tmdb.org/t/p/w500/RYMX2wcKCBAr24UyPD7xwmjaTn.jpg',
    },
    {
      'title': 'Titanic',
      'rating': '7.9',
      'image':
          'https://image.tmdb.org/t/p/w500/9xjZS2rlVxm8SFx8kPC3aIGCOYQ.jpg',
    },
  ];

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Text(
            'See All',
            style: TextStyle(
              color: accentColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  
Widget movieCard(Map<String, String> movie) {
  bool isFavorite = favoriteMovies.any(
    (item) => item['title'] == movie['title'],
  );

  return InkWell(
    onTap: () {
      showMovieDetail(movie);
    },
    borderRadius: BorderRadius.circular(12),
    child: Container(
      width: 125,
      margin: const EdgeInsets.only(right: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  movie['image']!,
                  width: 125,
                  height: 175,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 125,
                      height: 175,
                      color: cardColor,
                      child: const Icon(
                        Icons.movie,
                        color: Colors.white54,
                        size: 40,
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 2,
                right: 2,
                child: IconButton(
                  onPressed: () => toggleFavorite(movie),
                  icon: Icon(
                    isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: isFavorite
                        ? accentColor
                        : Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Text(
            movie['title']!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(
                Icons.star,
                color: Colors.amber,
                size: 15,
              ),
              const SizedBox(width: 4),
              Text(
                movie['rating']!,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

  Widget movieList(List<Map<String, String>> movies) {
    return SizedBox(
      height: 235,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return movieCard(movies[index]);
        },
      ),
    );
  }

  Widget featuredBanner() {
    return Container(
      height: 205,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        image: const DecorationImage(
          image: NetworkImage(
            'https://image.tmdb.org/t/p/w780/8Gxv8gSFCU0XGDykEGv7zR1n2ua.jpg',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [
              Colors.black87,
              Colors.transparent,
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'NOW PLAYING',
              style: TextStyle(
                color: accentColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                fontSize: 11,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Oppenheimer',
              style: TextStyle(
                color: Colors.white,
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Drama • History • 2023',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget homeContent() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                child: Row(
                  children: [
                    const Icon(
                      Icons.movie_filter,
                      color: accentColor,
                      size: 30,
                    ),
                    const SizedBox(width: 9),
                    const Text(
                      'CineMovie',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          selectedIndex = 1;
                        });
                      },
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 27,
                      ),
                    ),
                    const CircleAvatar(
                      radius: 17,
                      backgroundColor: cardColor,
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              featuredBanner(),
              sectionTitle('🔥 Trending Movies'),
              movieList(trendingMovies),
              sectionTitle('🎬 Popular Movies'),
              movieList(popularMovies),
              sectionTitle('⭐ Top Rated'),
              movieList(trendingMovies),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }


Widget favoritePage() {
  if (favoriteMovies.isEmpty) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 65,
            color: accentColor,
          ),
          SizedBox(height: 15),
          Text(
            'No Favorite Movies Yet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add your favorite movies here',
            style: TextStyle(color: Colors.white54),
          ),
        ],
      ),
    );
  }

  return GridView.builder(
    padding: const EdgeInsets.all(20),
    itemCount: favoriteMovies.length,
    gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 20,
      childAspectRatio: 0.65,
    ),
    itemBuilder: (context, index) {
      final movie = favoriteMovies[index];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    movie['image']!,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  right: 5,
                  top: 5,
                  child: IconButton(
                    onPressed: () => toggleFavorite(movie),
                    icon: const Icon(
                      Icons.favorite,
                      color: accentColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            movie['title']!,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '⭐ ${movie['rating']}',
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
        ],
      );
    },
  );
}

  Widget otherPage(String title, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 65, color: accentColor),
          const SizedBox(height: 15),
          Text(
            title,
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Explore your favorite movies',
            style: TextStyle(color: Colors.white54),
          ),
        ],
      ),
    );
  }

Widget profilePage() {
  final allMovies = [
    ...trendingMovies,
    ...popularMovies,
  ];

  return Scaffold(
    backgroundColor: bgColor,
    appBar: AppBar(
      backgroundColor: bgColor,
      title: const Text('My Profile'),
    ),
    body: Column(
      children: [
        const SizedBox(height: 15),
        const CircleAvatar(
          radius: 40,
          backgroundColor: cardColor,
          child: Icon(
            Icons.person,
            size: 45,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'CineMovie User',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
              ),
              onPressed: addMovie,
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              label: const Text(
                'Tambah Film',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        const Text(
          'Kelola Daftar Film',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: allMovies.length,
            itemBuilder: (context, index) {
              final movie = allMovies[index];

              return ListTile(
                leading: Image.network(
                  movie['image']!,
                  width: 45,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.movie,
                      color: Colors.white,
                    );
                  },
                ),
                title: Text(
                  movie['title']!,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  'Rating: ${movie['rating']}',
                  style: const TextStyle(color: Colors.white54),
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: accentColor,
                  ),
                  onPressed: () {
                    setState(() {
                      trendingMovies.remove(movie);
                      popularMovies.remove(movie);

                      favoriteMovies.removeWhere(
                        (item) => item['title'] == movie['title'],
                      );
                    });
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
@override
Widget build(BuildContext context) {
  final pages = [
  homeContent(),
  SearchMovieContent(
    movies: [...trendingMovies, ...popularMovies],
    onMovieTap: showMovieDetail,
  ),
  favoritePage(),
  profilePage(),
];

    return Scaffold(
      body: SafeArea(
        child: pages[selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: cardColor,
        selectedItemColor: accentColor,
        unselectedItemColor: Colors.white54,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
