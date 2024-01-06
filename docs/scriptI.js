function selectAnswer(quizId, selectedAnswer, element) {
    let correctAnswers = {
        "quiz1": ["C"],
        "quiz2": ["C"]
    };

    document.querySelectorAll(`#${quizId} ul li`).forEach(li => {
        li.classList.remove('correct-answer', 'wrong-answer');
    });

    // Get the feedback and hint elements for the quiz
    let feedback = document.querySelector(`#${quizId} .feedback`);
    let hint = document.querySelector(`#${quizId} .hint`);

    // Check if the selected answer is one of the correct answers
    if(correctAnswers[quizId].includes(selectedAnswer)) {
        // If it's correct, update feedback and styles accordingly
        feedback.innerHTML = "Correct!";
        hint.style.display = "none"; // Hide the hint
        element.classList.add('correct-answer'); // Highlight as correct
    } else {
        // If it's incorrect, update feedback and styles accordingly
        feedback.innerHTML = "Incorrect. Try again.";
        hint.style.display = "block"; // Show the hint
        element.classList.add('wrong-answer'); // Highlight as incorrect
    }
}
