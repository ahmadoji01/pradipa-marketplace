<script type="text/javascript">
!function(w,h,a,t,s,p){
    w.whatsapp || (
    s = h.createElement(a),
    s.src = t,
    p = h.getElementsByTagName(a)[0],
    p.parentNode.insertBefore(s, p)
)}(window, document, "script", "https://cdn.jsdelivr.net/gh/miguelcolmenares/whatsapp-widget/dist/js/whatsapp-widget.js");
window.addEventListener('load', function(){
    new whatsapp({
        agents:[{
            name: "Servicio al cliente",
            phone: "+57 320 1234567",
            hours: "Disponible 9am - 6pm",
            cta: "Haz clic para iniciar chat",
            schedule: [
                ["9:00", "18:00"], //Sundays or Holidays
                ["9:00", "20:00"],
                ["9:00", "20:00"],
                ["9:00", "20:00"],
                ["9:00", "20:00"],
                ["9:00", "22:00"],
                ["10:00", "18:00"] // Saturday
            ]
        },{
            name: "Soporte técnico",
            phone: "+57 320 7654321",
            hours: "Disponible 9am - 6pm",
            cta: "Haz clic para iniciar chat"
        }]
    })
});
</script>