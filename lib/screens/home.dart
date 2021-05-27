import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_paginator/flutter_paginator.dart';
import 'package:last_trial/model/movie_data.dart';


    class HomePage extends StatefulWidget {
      @override
      State<StatefulWidget> createState() {
        return HomeState();
      }
    }

    class HomeState extends State<HomePage> {
      GlobalKey<PaginatorState> paginatorGlobalKey = GlobalKey();

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Movie List'),),
          body: Paginator.listView(
            key: paginatorGlobalKey,
            pageLoadFuture: sendMoviesDataRequest,
            pageItemsGetter: listItemsGetter,
            listItemBuilder: listItemBuilder,
            loadingWidgetBuilder: loadingWidgetMaker,
            errorWidgetBuilder: errorWidgetMaker,
            emptyListWidgetBuilder: emptyListWidgetMaker,
            totalItemsGetter: totalPagesGetter,
            pageErrorChecker: pageErrorChecker,
            scrollPhysics: BouncingScrollPhysics(),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              paginatorGlobalKey.currentState.changeState(
                  pageLoadFuture: sendMoviesDataRequest, resetState: true);
            },
            child: Icon(Icons.refresh),
          ),
        );
      }

      Future<MovieData> sendMoviesDataRequest(int page) async {
        print('page ${page}');
        try {
          String url = Uri.encodeFull(
            'http://api.themoviedb.org/3/discover/movie?api_key=acea91d2bff1c53e6604e4985b6989e2&page=$page&format=json');
          http.Response response = await http.get(url);
          print('body ${response.body}');
          return MovieData.fromResponse(response);
        } catch (e) {
          if (e is IOException) {
            return MovieData.withError(
                'Please check your internet connection.');
          } else {
            print(e.toString());
            return MovieData.withError('Something went wrong.');
          }
        }
      }

      List<dynamic> listItemsGetter(MovieData moviesData) {
        List<String> list = [];
        moviesData.movies.forEach((value) {
          list.add(value['title']);
          list.add(value['overview']);
        });
        return list;
      }

      Widget listItemBuilder(value, int index) {
        return ListTile(
          title: Text(value),

        );
      }

      Widget loadingWidgetMaker() {
        return Container(
          alignment: Alignment.center,
          height: 160.0,
          child: CircularProgressIndicator(),
        );
      }

      Widget errorWidgetMaker(MovieData moviesData, retryListener) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(moviesData.errorMessage),
            ),
            FlatButton(
              onPressed: retryListener,
              child: Text('Retry'),
            )
          ],
        );
      }

      Widget emptyListWidgetMaker(MovieData moviesData) {
        return Center(
          child: Text('No Movies in the list'),
        );
      }

      int totalPagesGetter(MovieData moviesData) {
        return moviesData.total;
      }

      bool pageErrorChecker(MovieData moviesData) {
        return moviesData.statusCode != 200;
      }
    }
