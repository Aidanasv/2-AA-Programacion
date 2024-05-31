<%@ page import="com.svalero.musicvibe.dao.Database" %>
<%@ page import="com.svalero.musicvibe.domain.Track" %>
<%@ page import="com.svalero.musicvibe.dao.TrackDao" %>
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
                url: "edit-track",
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

  int id_Track;
  int id_Album;
  Track track = null;
  if (request.getParameter("id_track") == null) {
    id_Track = 0;
  } else {
    id_Track = Integer.parseInt(request.getParameter("id_track"));
    Database.connect();
    track = Database.jdbi.withExtension(TrackDao.class, dao -> dao.getTrack(id_Track));
  }

  if (request.getParameter("id_album") == null && track != null) {
    id_Album = track.getId_album();
  } else {
    id_Album = Integer.parseInt(request.getParameter("id_album"));
  }
%>

<main>
  <section class="py-5 container">
    <% if (id_Track == 0) {%>
    <h1>Registrar nueva Canción</h1>
    <% } else {%>
    <h1>Modificar Canción</h1>
    <% } %>

    <form class="row g-3 needs-validation" method="post" enctype="multipart/form-data" id="edit-form">

      <div class="mb-3">
        <label for="name" class="form-label">Nombre</label>
        <input type="text" name="name" class="form-control" id="name" placeholder="Nombre de la Canción"
          <% if (id_Track != 0) { %> value="<%= track.getName() %>"<% } %>>
      </div>

      <div class="col-md-4">
        <label for="audio" class="form-label">Audio</label>
        <input type="file" name="audio" class="form-control" id="audio"
          <% if (id_Track != 0) { %> value="<%= track.getAudio() %>"<% } %>>
      </div>

      <div class="col-md-4">
        <label for="duration" class="form-label">Duración</label>
        <input type="text" name="duration" class="form-control" id="duration"
          <% if (id_Track != 0) { %> value="<%= track.getDuration() %>"<% } %>>
      </div>

      <div class="col-12">
        <input type="submit" class="btn btn-success" value="Enviar" id="edit-button"/>
        <a class="btn btn-success" href="view-album.jsp?id=<%= id_Album %>">Volver</a>
      </div>
      <input type="hidden" name="id_track" value="<%= id_Track %>"/>
      <input type="hidden" name="id_album" value="<%= id_Album %>"/>
    </form>
    <br>
    <div id="result" class="w-25"></div>
  </section>
</main>

<%@include file="includes/footer.jsp" %>