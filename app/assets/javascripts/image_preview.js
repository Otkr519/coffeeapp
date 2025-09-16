document.addEventListener("DOMContentLoaded", () => {
  const input = document.getElementById("image_input");
  const preview = document.getElementById("image_preview");

  if (!input || !preview) return;

  input.addEventListener("change", (event) => {
    const file = event.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = (e) => {
        preview.src = e.target.result;
      };
      reader.readAsDataURL(file);
    }
  });
});
