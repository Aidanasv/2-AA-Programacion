package com.svalero.musicvibe.dao;

import com.svalero.musicvibe.domain.Playlist;
import org.jdbi.v3.sqlobject.statement.SqlQuery;
import org.jdbi.v3.sqlobject.statement.SqlUpdate;
import org.jdbi.v3.sqlobject.statement.UseRowMapper;

import java.util.List;

public interface PlaylistDao {

    @SqlQuery("SELECT * FROM playlists WHERE id_user = ?")
    @UseRowMapper(PlaylistMapper.class)
    List<Playlist> getAllPlaylist(int id_user);

    @SqlUpdate("INSERT INTO playlists (id_user, name) VALUES (?,?)")
    int addPlaylist(int user, String name);

    @SqlUpdate("DELETE FROM playlists WHERE id_playlist = ?")
    int removePlaylist(int id_playlist);

    @SqlUpdate("INSERT INTO tracks_playlists (id_playlist, id_track) VALUES (?,?)")
    int addTrackIntoPlaylist(int id_playlist, int id_track);

    @SqlUpdate("DELETE FROM tracks_playlists WHERE id_track = ? AND id_playlist = ?")
    int removeTrackFromPlaylist(int id_track, int id_playlist);
}
