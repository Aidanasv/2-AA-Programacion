package com.svalero.musicvibe.dao;

import com.svalero.musicvibe.domain.AlbumTracksArtist;
import org.jdbi.v3.sqlobject.statement.SqlQuery;
import org.jdbi.v3.sqlobject.statement.UseRowMapper;

import java.util.List;

public interface AlbumTracksArtistDao {

    @SqlQuery("SELECT tr.id_track AS idTrack, tr.NAME AS nameTrack, tr.DURATION AS durationTrack , ar.name AS artistName , al.name AS albumName, al.picture AS albumPicture, tr.audio AS audioTrack FROM tracks tr INNER JOIN album al ON tr.ID_ALBUM=al.id_album INNER JOIN artists ar ON al.id_artist =ar.id_artist WHERE tr.ID_TRACK NOT IN (SELECT id_track FROM tracks_playlists WHERE id_playlist = ?)")
    @UseRowMapper(AlbumTracksArtistMapper.class)
    List<AlbumTracksArtist> getAllAlbumTracksArtist(int idPlaylist);

    @SqlQuery("SELECT tr.id_track AS idTrack, tr.NAME AS nameTrack, tr.DURATION AS durationTrack , ar.name AS artistName , al.name AS albumName, al.picture AS albumPicture, tr.audio AS audioTrack FROM tracks tr INNER JOIN tracks_playlists tp ON tr.ID_TRACK=tp.ID_TRACK INNER JOIN album al ON tr.ID_ALBUM=al.id_album INNER JOIN artists ar ON al.id_artist =ar.id_artist WHERE tp.ID_PLAYLIST = ?")
    @UseRowMapper(AlbumTracksArtistMapper.class)
    List<AlbumTracksArtist> getAllAlbumTracksArtistByPlaylist(int idPlaylist);
}
