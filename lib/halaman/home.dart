import 'package:flutter/material.dart';
import 'package:mws_pert7/service/api_service.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ApiService apiService = ApiService();
  List posts = [];

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      final data = await apiService.fetchPosts();
      setState(() {
        posts = data;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> deletePost(int id) async {
    bool success = await apiService.deletePost(id);
    if (success) {
      setState(() {
        posts.removeWhere((post) => post['id'] == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post deleted successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete post')),
      );
    }
  }

  void _showDeleteConfirmationDialog(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Hapus Postingan"),
          content: Text("Apakah Anda yakin ingin menghapus postingan ini?"),
          actions: [
            TextButton(
              child: Text("Batal"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Hapus"),
              onPressed: () {
                Navigator.of(context).pop();
                deletePost(id);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halaman Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/create').then((value) {
                if (value == true) {
                  fetchPosts();
                }
              });
            },
          ),
        ],
      ),
      body: posts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              title: Text(
                post['title'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(post['body']),
              onTap: () {
                Navigator.pushNamed(context, '/edit', arguments: post).then((value) {
                  if (value == true) {
                    fetchPosts();
                  }
                });
              },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      Navigator.pushNamed(context, '/edit', arguments: post).then((value) {
                        if (value == true) {
                          fetchPosts();
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _showDeleteConfirmationDialog(post['id']);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
