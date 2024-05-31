package com.svalero.musicvibe.servlet;
import com.svalero.musicvibe.dao.Database;
import com.svalero.musicvibe.dao.PlaylistDao;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

import static com.svalero.musicvibe.util.ErrorUtils.sendError;
import static com.svalero.musicvibe.util.ErrorUtils.sendMessage;

@WebServlet("/view-playlist")
@MultipartConfig
public class PlaylistServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");

        HttpSession currentSession = request.getSession();
        if (currentSession.getAttribute("role") != null) {
            if (!currentSession.getAttribute("role").equals("admin")) {
                response.sendRedirect("/MusicVibe");
            }
        }

        try {
            if (hasValidationErrors(request, response))
                return;

            int id_user = Integer.parseInt(request.getParameter("id_user"));
            String name = request.getParameter("name");

            Database.connect();
            Database.jdbi.withExtension(PlaylistDao.class,
                    dao -> dao.addPlaylist(id_user, name));
            sendMessage("Playlist creada correctamente", response);

        } catch (ClassNotFoundException cnfe) {
            cnfe.printStackTrace();
            sendError("Internal Server Error", response);
        } catch (SQLException sql) {
            sql.printStackTrace();
            sendError("Error conectando con la base de datos", response);
        }
    }

    private boolean hasValidationErrors(HttpServletRequest request, HttpServletResponse response) throws IOException {
        boolean hasErrors = false;

        if (request.getParameter("name").isBlank()) {
            sendError("El nombre es un campo obligatorio", response);
            hasErrors = true;
        }
        return hasErrors;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id_playlist"));
        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");

        try {
            Database.connect();
            Database.jdbi.withExtension(PlaylistDao.class,
                    dao -> dao.removePlaylist(id));
            response.getWriter().print("ok");
        } catch (ClassNotFoundException cnfe) {
            cnfe.printStackTrace();
            sendError("Error eliminando la playlist", response);
        } catch (SQLException sql) {
            sql.printStackTrace();
            sendError("Error eliminando la playlist", response);
        } catch (Exception e) {
            e.printStackTrace();
            sendError("Error eliminando la playlist", response);
        }
    }
}