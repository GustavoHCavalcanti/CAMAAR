let questionIndex = document.querySelectorAll(".question-block").length;

// Adiciona nova questão
function addQuestion() {
  fetch(`/admin/templates/new_question/${questionIndex}`)
    .then(response => response.text())
    .then(html => {
      document.getElementById("questions-container").insertAdjacentHTML("beforeend", html);
      questionIndex++;
    });
}

// Adiciona opções
document.addEventListener("click", (e) => {
  if (e.target.classList.contains("add-option")) {
    const qIndex = e.target.getAttribute("data-question");
    const container = document.getElementById(`options-${qIndex}`);

    container.insertAdjacentHTML(
      "beforeend",
      `<input type="text" name="template[questions][${qIndex}][options][]" placeholder="Placeholder"
        style="border: none; border-bottom: 2px solid #333; width: 100%; margin-bottom: 10px;">`
    );
  }
});