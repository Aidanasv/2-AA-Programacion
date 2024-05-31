package com.svalero.musicvibe.dao;

import com.svalero.musicvibe.domain.Artist;
import org.jdbi.v3.sqlobject.customizer.Bind;
import org.jdbi.v3.sqlobject.statement.SqlQuery;
import org.jdbi.v3.sqlobject.statement.SqlUpdate;
import org.jdbi.v3.sqlobject.statement.UseRowMapper;

import java.util.List;

public interface ArtistsDao {
    @SqlQuery("SELECT * FROM artists")
    @UseRowMapper(ArtistsMapper.class)
    List<Artist> getAllArtists();

    @SqlQuery("SELECT * FROM artists WHERE name LIKE :searchTerm or genre LIKE :searchTerm")
    @UseRowMapper(ArtistsMapper.class)
    List<Artist> getAllArtistsBySearch(@Bind("searchTerm") String searchTerm);

    @SqlQuery("SELECT * FROM artists WHERE id_artist = ?")
    @UseRowMapper(ArtistsMapper.class)
    Artist getArtist(int id);

    @SqlUpdate("INSERT INTO artists (name, picture, genre) VALUES (?,?,?)")
    int addArtist(String name, String picture, String genre);

    @SqlUpdate ("UPDATE  artists SET name = ?, picture = ? ,genre = ? WHERE id_artist = ?")
    int updateArtist(String name, String picture, String genre, int id);

    @SqlUpdate("DELETE FROM artists WHERE id_artist = ?")
    int removeArtist(int id);
}
