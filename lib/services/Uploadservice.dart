
import 'package:movie_list/database/db_operation.dart';
import 'package:movie_list/models/Movie.dart';

class Uploadservice{

  db_operations _dbo=db_operations();

  saveMovie(Movie movie) async{
    print(movie.uid);
    print(movie.name);
    print(movie.director);
    print(movie.image);
    return await _dbo.save('movielist', movie.movieMap());
  }

  getMovies() async{
    return await _dbo.getall('movielist');
  }

  getMovieById(id) async{
    return await _dbo.getById('movielist',id);
  }
  updateMovie(Movie movie) async{
    print(movie.uid);
    print(movie.name);
    print(movie.director);
    print(movie.image);
    return await _dbo.update('movielist', movie.movieMap());
  }
  deleteMovie(mid) async{
    return await _dbo.delete('movielist',mid);
  }
}