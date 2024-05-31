package com.svalero.musicvibe.servlet;

import com.svalero.musicvibe.dao.Database;
import com.svalero.musicvibe.dao.PlaylistDao;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

import static com.svalero.musicvibe.util.ErrorUtils.sendError;

@WebServlet("/edit-playlist")
@MultipartConfig
public class TracksPlaylistServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");


        try {
            int id_track = Integer.parseInt(request.getParameter("id_track"));
            int id_playlist = Integer.parseInt(request.getParameter("id_playlist"));

            Database.connect();
            Database.jdbi.withExtension(PlaylistDao.class,
                    dao -> dao.addTrackIntoPlaylist(id_playlist, id_track));
            response.getWriter().print("ok");

        } catch (ClassNotFoundException cnfe) {
            cnfe.printStackTrace();
            sendError("Internal Server Error", response);
        } catch (SQLException sql) {
            sql.printStackTrace();
            sendError("Error conectando con la base de datos", response);
        } catch (Exception e) {
            e.printStackTrace();
            sendError("Error", response);
        }
    }


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id_track = Integer.parseInt(request.getParameter("id_track"));
        int id_playlist = Integer.parseInt(request.getParameter("id_playlist"));

        try {
            Database.connect();
            Database.jdbi.withExtension(PlaylistDao.class,
                    dao -> dao.removeTrackFromPlaylist(id_track, id_playlist));
            response.getWriter().print("ok");
        } catch (ClassNotFoundException cnfe) {
            cnfe.printStackTrace();
            sendError("No se puede eliminar el track de la playlist", response);
        } catch (SQLException sql) {
            sql.printStackTrace();
            sendError("No se puede eliminar el track de la playlist", response);
        }catch (Exception e) {
            e.printStackTrace();
            sendError("No se puede eliminar el track de la playlist", response);
        }
    }
}
