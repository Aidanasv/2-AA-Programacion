package com.svalero.musicvibe.servlet;

import com.svalero.musicvibe.dao.AlbumDao;
import com.svalero.musicvibe.dao.Database;
import com.svalero.musicvibe.util.DateUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.Date;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.UUID;

import static com.svalero.musicvibe.util.ErrorUtils.sendError;
import static com.svalero.musicvibe.util.ErrorUtils.sendMessage;

@WebServlet("/edit-album")
@MultipartConfig
public class AlbumServlet extends HttpServlet {

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

            int id = 0;
            if (request.getParameter("id_album") != null) {
                id = Integer.parseInt(request.getParameter("id_album"));
            }

            int id_artist = Integer.parseInt(request.getParameter("id_artist"));
            String name = request.getParameter("name");
            Part picturePart = request.getPart("picture");
            Date release_date = DateUtils.parse(request.getParameter("release_date"));

            String imagePath = request.getServletContext().getInitParameter("image-path");
            String filename = null;

            filename = UUID.randomUUID() + ".jpg";
            InputStream fileStream = picturePart.getInputStream();
            Files.copy(fileStream, Path.of(imagePath + File.separator + filename));

            Database.connect();
            final String finalFilename = filename;
            if (id == 0) {
                Database.jdbi.withExtension(AlbumDao.class,
                        dao -> dao.addAlbum(id_artist, name, finalFilename, release_date));
                sendMessage("Álbum registrado correctamente", response);
            } else {
                final int finalId = id;
                Database.jdbi.withExtension(AlbumDao.class,
                        dao -> dao.updateAlbum(id_artist, name, finalFilename, release_date, finalId));
                sendMessage("Álbum modificado correctamente", response);
            }

        } catch (ClassNotFoundException cnfe) {
            cnfe.printStackTrace();
            sendError("Internal Server Error", response);
        } catch (SQLException sql) {
            sql.printStackTrace();
            sendError("Error conectando con la base de datos", response);
        } catch (ParseException pe) {
            pe.printStackTrace();
            sendError("Error parsing data", response);
        } catch (Exception e) {
            e.printStackTrace();
            sendError("Error", response);
        }
    }

    private boolean hasValidationErrors(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        boolean hasErrors = false;

        if (request.getParameter("name").isBlank()) {
            sendError("El nombre es un campo obligatorio", response);
            hasErrors = true;
        }

        if (request.getPart("picture").getSize() == 0) {
            sendError("La imágen es un campo obligatorio", response);
            hasErrors = true;
        }

        try{
            DateUtils.parse(request.getParameter("release_date"));
        }catch (ParseException pe) {
            sendError("Formato de fecha no válido", response);
            hasErrors = true;
        }
        return hasErrors;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id_album"));
        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");

        try {
            Database.connect();
            Database.jdbi.withExtension(AlbumDao.class,
                    dao -> dao.removeAlbum(id));
            response.getWriter().print("ok");
        } catch (ClassNotFoundException cnfe) {
            cnfe.printStackTrace();
            sendError("Error al eliminar el Álbum", response);
        } catch (SQLException sql) {
            sql.printStackTrace();
            sendError("Error al eliminar el Álbum", response);
        } catch (Exception e) {
            e.printStackTrace();
            sendError("Error al eliminar el Álbum", response);
        }
    }
}