library(stringr)

convert_quizzes_R_to_HTML <- function(quizzes_list, file_name = "output.html", custom_id_prefix = "quiz") {
  html_output <- ""
  
  # Process each quiz
  for (quiz_index in 1:length(quizzes_list)) {
    quiz_r_string <- quizzes_list[[quiz_index]]
    
    # Ensure quiz_r_string is a single string
    if (is.character(quiz_r_string) && length(quiz_r_string) > 1) {
      quiz_r_string <- paste(quiz_r_string, collapse = "\n")
    }
    
    # Split the string into lines for the current quiz
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
    
    # Generate HTML for each quiz
    for (q in 1:length(questions)) {
      if (is.null(answers_per_question[[q]])) {
        cat("Skipping question", q, "in quiz", quiz_index, "due to missing answers.\n")
        next
      }
      question_id <- paste0(custom_id_prefix, quiz_index)  # Updated to remove "_", only quiz index is appended
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
  }
  
  writeLines(html_output, file_name)
  cat("HTML content written to", file_name)
  return(html_output)
}

# Now use the adapted or original function to convert these quizzes to HTML
# convert_quizzes_R_to_HTML(individual_quizzes, file_name = "output.html", custom_id_prefix = "quiz")


library(stringr)

extract_quizzes_from_rmd <- function(rmd_content) {
  individual_quizzes <- list()
  lines <- unlist(strsplit(rmd_content, "\n"))
  start_indices <- grep("^```\\{r", lines)
  end_indices <- grep("^```$", lines)
  
  if (length(start_indices) != length(end_indices) || length(start_indices) < 1) {
    stop("Mismatch in the number of start and end indices for R chunks, or no quizzes found")
  }
  
  for (i in 1:length(start_indices)) {
    quiz_lines <- lines[(start_indices[i] + 1):(end_indices[i] - 1)]
    # Check if this chunk contains a quiz by looking for lines starting with 'question('
    if (any(grepl("^question\\(", quiz_lines))) {
      individual_quizzes[[length(individual_quizzes) + 1]] <- paste(quiz_lines, collapse = "\n")
    }
  }
  return(individual_quizzes)
}


# Example usage
setwd("E:/GitHub/EpiMethods/Quiz")
getwd()
file_path <- "quizMediation.Rmd"
rmd_content <- readLines(file_path)

# Preprocess and extract individual quizzes
individual_quizzes <- extract_quizzes_from_rmd(rmd_content)

# Now use the adapted or original function to convert these quizzes to HTML
# You might need to further adapt the function depending on the exact structure and formatting of your quizzes
convert_quizzes_R_to_HTML(individual_quizzes, file_name = "mediationQi.html", custom_id_prefix = "quiz")
