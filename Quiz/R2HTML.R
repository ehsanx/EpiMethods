library(stringr)

convert_quiz_R_to_HTML <- function(quiz_r_string, file_name = "output.html", custom_id_prefix = "quiz") {
  # Split the string into lines
  lines <- unlist(strsplit(quiz_r_string, "\n"))
  
  # Identify the lines that are questions, answers, and hints
  question_lines <- lines[grepl("^question\\(", lines)]
  answer_lines <- lines[grepl("^  answer\\(", lines)]
  hint_lines <- lines[grepl("^  incorrect\\s*=", lines)]
  
  # Extract the actual text of questions, answers, and hints
  questions <- gsub("question\\(\"([^\"]*)\".*", "\\1", question_lines)
  answers <- gsub("answer\\(\"([^\"]*)\".*\\)", "\\1", answer_lines)
  hints <- ifelse(length(hint_lines) > 0, gsub("incorrect\\s*=\\s*\"([^\"]*)\".*", "\\1", hint_lines), "")
  
  # Split answers into groups for each question
  num_questions <- length(questions)
  answers_per_question <- split(answers, rep(1:num_questions, each = length(answers)/num_questions, length.out = length(answers)))
  
  # Start generating HTML
  html_output <- ""
  
  for (q in 1:length(questions)) {
    if (is.null(answers_per_question[[q]])) {
      stop(paste("No answers found for question", q))
    }
    # Use only the custom_id_prefix for the first question
    question_id <- ifelse(q == 1, custom_id_prefix, paste0(custom_id_prefix, q))
    html_output <- paste0(html_output, "<div class=\"quiz-container\" id=\"", question_id, "\">")
    html_output <- paste0(html_output, "<div class=\"question\">", questions[q], "</div>")
    html_output <- paste0(html_output, "<ul>")
    
    # Generate list items for answers
    current_answers <- answers_per_question[[q]]
    for (a in 1:length(current_answers)) {
      clean_answer <- gsub("^\\w\\.\\s*", "", current_answers[a])
      clean_answer <- gsub(",\\s*$", "", clean_answer)
      html_output <- paste0(html_output, "<li onclick=\"selectAnswer('", question_id, "', '", LETTERS[a], "', this)\">", LETTERS[a], ". ", clean_answer, "</li>")
    }
    
    html_output <- paste0(html_output, "</ul>")
    html_output <- paste0(html_output, "<div class=\"feedback\"></div>")
    
    # Include the hint text
    if (q <= length(hints)) {
      html_output <- paste0(html_output, "<div class=\"hint\" style=\"display:none;\">", hints[q], "</div>")
    } else {
      html_output <- paste0(html_output, "<div class=\"hint\" style=\"display:none;\">Select the answer that is more appropriate.</div>")
    }
    html_output <- paste0(html_output, "</div>")
  }
  
  writeLines(html_output, file_name)
  cat("HTML content written to", file_name)
  return(html_output)
}

# Example usage
quiz_r_string <- 'question("Q2. Suppose you are interested in exploring whether demographic factors, such as age, sex, and race/ethnicity, are associated with obesity among US adults. To extract the `obesity` information defined as body mass index greater than or equal to 30 kg/m^2 from the NHANES 2017-18 cycle, which data file do you need to access?",
  answer("DEMO_J", message = "Hints: CDC uses a file name to characterize a type of data file"),
  answer("BMX_H", message = "Hints: CDC uses an index number to characterize each cycle"),
  answer("BMX_J", correct = TRUE),
  answer("DBQ_H", message = "Hints: CDC uses an index number to characterize each cycle"),
  allow_retry = TRUE,
  random_answer_order = TRUE
)'

convert_quiz_R_to_HTML(quiz_r_string, file_name = "output.html", custom_id_prefix = "quiz1")
