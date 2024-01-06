function selectAnswer(quizId, selectedAnswer, element) {
    let correctAnswers = {
        "quiz1": "C",
        "quiz2": "A",
        "quiz3": "A",
        "quiz4": "A",
        "quiz5": "B",
        "quiz6": "B",
        "quiz7": "B",
        "quiz8": "B",
        "quiz9": "B",
        "quiz10": "C",
        "quiz11": "B",
        "quiz12": "B"
    };

    document.querySelectorAll(`#${quizId} ul li`).forEach(li => {
        li.classList.remove('correct-answer', 'wrong-answer');
    });

    let feedback = document.querySelector(`#${quizId} .feedback`);
    let hint = document.querySelector(`#${quizId} .hint`); // Get the hint element

    if(selectedAnswer === correctAnswers[quizId]) {
        feedback.innerHTML = "Correct!";
        hint.style.display = "none"; // Hide the hint if the answer is correct
        element.classList.add('correct-answer');
    } else {
        feedback.innerHTML = "Incorrect. Try again.";
        hint.style.display = "block"; // Show the hint for incorrect answers
        element.classList.add('wrong-answer');
    }
}
