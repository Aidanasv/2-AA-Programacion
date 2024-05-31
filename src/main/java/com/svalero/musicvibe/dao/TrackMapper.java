package com.svalero.musicvibe.dao;

import com.svalero.musicvibe.domain.Track;
import org.jdbi.v3.core.statement.StatementContext;
import org.jdbi.v3.core.mapper.RowMapper;
import java.sql.ResultSet;
import java.sql.SQLException;

public class TrackMapper implements RowMapper<Track> {

    @Override
    public Track map(ResultSet rs, StatementContext ctx) throws SQLException {
        return new Track(rs.getInt("id_track"),
                rs.getInt("id_album"),
                rs.getString("name"),
                rs.getInt("duration"),
                rs.getString("audio"));
    }
}
