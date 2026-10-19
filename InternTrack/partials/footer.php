</section></main></div><script>
document.querySelectorAll('form[data-confirm]').forEach(form=>form.addEventListener('submit',e=>{if(!confirm(form.dataset.confirm)){e.preventDefault();}}));
</script></body></html>
