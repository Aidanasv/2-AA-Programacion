package com.svalero.musicvibe.dao;

import com.svalero.musicvibe.domain.Track;
import org.jdbi.v3.sqlobject.customizer.Bind;
import org.jdbi.v3.sqlobject.statement.SqlQuery;
import org.jdbi.v3.sqlobject.statement.SqlUpdate;
import org.jdbi.v3.sqlobject.statement.UseRowMapper;

import java.util.List;

public interface TrackDao {

    @SqlQuery("SELECT * FROM tracks WHERE id_track = ?")
    @UseRowMapper(TrackMapper.class)
    Track getTrack(int id_track);

    @SqlQuery("SELECT * FROM tracks WHERE id_album = ?")
    @UseRowMapper(TrackMapper.class)
    List<Track> getAllTracks(int id_album);

    @SqlQuery("SELECT * FROM tracks WHERE id_album = :id AND (name LIKE :searchTerm or (concat(LPAD(DURATION div 60, 2, '0'), \":\",  LPAD(mod(DURATION, 60), 2, '0') )) LIKE :searchTerm)")
    @UseRowMapper(TrackMapper.class)
    List<Track> getAllTrackBySearch(@Bind("searchTerm") String searchTerm, @Bind("id") int id_album);

    @SqlUpdate("INSERT INTO tracks (id_album, name, duration, audio) VALUES (?,?,?,?)")
    int addTrack(int id_album, String name, int duration, String audio);

    @SqlUpdate ("UPDATE tracks SET name = ?, duration = ?, audio = ? WHERE id_track = ?")
    int updateTrack(String name, int duration, String audio, int id_track);

    @SqlUpdate("DELETE FROM tracks WHERE id_track = ?")
    int removeTrack(int id_track);

}
