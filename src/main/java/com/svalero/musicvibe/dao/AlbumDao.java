package com.svalero.musicvibe.dao;

import com.svalero.musicvibe.domain.Album;
import org.jdbi.v3.sqlobject.customizer.Bind;
import org.jdbi.v3.sqlobject.statement.SqlQuery;
import org.jdbi.v3.sqlobject.statement.SqlUpdate;
import org.jdbi.v3.sqlobject.statement.UseRowMapper;

import java.sql.Date;
import java.util.List;

public interface AlbumDao {
    @SqlQuery("SELECT * FROM album")
    @UseRowMapper(AlbumMapper.class)
    List<Album> getAllAlbum();

    @SqlQuery("SELECT * FROM album WHERE id_artist = :id AND (name LIKE :searchTerm or release_date LIKE :searchTerm)")
    @UseRowMapper(AlbumMapper.class)
    List<Album> getAllAlbumBySearch(@Bind("searchTerm") String searchTerm, @Bind("id") int id_artist);

    @SqlQuery("SELECT * FROM album WHERE id_album = ?")
    @UseRowMapper(AlbumMapper.class)
    Album getAlbum(int id_album);

    @SqlQuery("SELECT * FROM album WHERE id_artist = ?")
    @UseRowMapper(AlbumMapper.class)
    List<Album> getAlbumByArtist(int id_artist);

    @SqlUpdate("INSERT INTO album (id_artist, name, picture, release_date) VALUES (?,?,?,?)")
    int addAlbum(int id_artist, String name, String picture, Date releaseDate);

    @SqlUpdate ("UPDATE  album SET id_artist = ?, name = ?, picture = ?, release_date = ? WHERE id_album = ?")
    int updateAlbum(int id_artist, String name, String picture, Date release_date, int id_album);

    @SqlUpdate("DELETE FROM album WHERE id_album = ?")
    int removeAlbum(int id_album);
}
