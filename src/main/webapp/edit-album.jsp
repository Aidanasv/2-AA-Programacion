<%@ page import="com.svalero.musicvibe.domain.Album" %>
<%@ page import="com.svalero.musicvibe.dao.Database" %>
<%@ page import="com.svalero.musicvibe.dao.AlbumDao" %>
<%@ page import="com.svalero.musicvibe.util.DateUtils" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@include file="includes/header.jsp" %>

<script>
    $(document).ready(function () {
        $("#edit-button").click(function (event) {
            event.preventDefault();
            const form = $("#edit-form")[0];
            const data = new FormData(form);

            $("#edit-button").prop("disabled", true);

            $.ajax({
                type: "POST",
                enctype: "multipart/form-data",
                url: "edit-album",
                data: data,
                processData: false,
                contentType: false,
                cache: false,
                timeout: 600000,
                success: function (data) {
                    $("#result").html(data);
                    $("#edit-button").prop("disabled", false);
                },
                error: function (error) {
                    $("#result").html(error.responseText);
                    $("#edit-button").prop("disabled", false);
                }
            });
        });
    });
</script>

<%
  if (!role.equals("admin")) {
    response.sendRedirect("/MusicVibe");
  }

  int id;
  int id_artist;
  Album album = null;
  if (request.getParameter("id_album") == null) {
    id = 0;
  } else {
    id = Integer.parseInt(request.getParameter("id_album"));
    Database.connect();
    album = Database.jdbi.withExtension(AlbumDao.class, dao -> dao.getAlbum(id));
  }

  if (request.getParameter("id") == null && album != null) {
    id_artist = album.getId_artist();
  } else {
    id_artist = Integer.parseInt(request.getParameter("id"));
  }
%>

<main>
  <section class="py-5 container">
    <% if (id == 0) {%>
    <h1>Registrar nuevo Album</h1>
    <% } else {%>
    <h1>Modificar Album</h1>
    <% } %>

    <form class="row g-3 needs-validation" method="post" enctype="multipart/form-data" id="edit-form">

      <div class="mb-3">
        <label for="name" class="form-label">Nombre</label>
        <input type="text" name="name" class="form-control" id="name" placeholder="Nombre del Álbum"
          <% if (id != 0) { %> value="<%= album.getName() %>"<% } %>>
      </div>

      <div class="col-md-4">
        <label for="picture" class="form-label">Foto</label>
        <input type="file" name="picture" class="form-control" id="picture"
          <% if (id != 0) { %> value="<%= album.getPicture() %>"<% } %>>
      </div>

      <div class="col-md-4">
        <label for="release_date" class="form-label">Fecha</label>
        <input type="date" name="release_date" class="form-control" id="release_date" placeholder="dd/mm/yyyy"
          <% if (id != 0) { %> value="<%= DateUtils.format(album.getRelease_date()) %>"<% } %>>
      </div>

      <div class="col-12">
        <input type="submit" class="btn btn-success" value="Enviar" id="edit-button"/>
        <a class="btn btn-success" href="view-artist.jsp?id=<%= id_artist %>">Volver</a>
      </div>
      <input type="hidden" name="id_album" value="<%= id %>"/>
      <input type="hidden" name="id_artist" value="<%= id_artist %>"/>
    </form>
    <br>
    <div id="result" class="w-25"></div>
  </section>
</main>

<%@include file="includes/footer.jsp" %>