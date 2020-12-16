
#' TSD Data reader
#'
#' Read data from a TSD data folder
#' data\_exp\_\{ExperimentID\}\_\{ExperimentName\}\_\{Session\}
#' containing files S\{Session\}\_\{UniqueName\}\_r\{Run\}.csv
#' In the two lines above, expressions between \{\} are all optional.
#'
#' NOTE: the data can easily be passed to dplyr verbs.
#'
#' @param DataDir the root directory where all data_exp_* folders are found.
#' @param ExperimentName a country label, as defined [here](https://docs.google.com/spreadsheets/d/1p6_WHQXNGFw2EJGny1jb5qivMy2pJ_VRRYoDGRLxgbY/edit#gid=0).
#' @param ExperimentID Experiment ID number to extract, as defined [here](https://docs.google.com/spreadsheets/d/1p6_WHQXNGFw2EJGny1jb5qivMy2pJ_VRRYoDGRLxgbY/edit#gid=0).
#' @param UniqueName Task or Questionnaire name, as defined [here](https://docs.google.com/spreadsheets/d/1p6_WHQXNGFw2EJGny1jb5qivMy2pJ_VRRYoDGRLxgbY/edit#gid=0).
#' @param Session Session name (1, 2, 3, control...).
#' @param Run Run number (1, 2, 3).
#' @param clean whether or not to clean output from less usefull data (such as checkpoints, schedule ID etc.).
#' @param verbose whether or not to display debugging info.
#'
#' @return a tibble: data for a specific selection of data.
#' @details This function looks for appropriately formatted data in directory DataDir.
#' @examples
#'\dontrun{
#'
#'    mydata <- gimmedata(ExperimentName = 'FR',UniqueName = 'Implicit')
#'
#'    mydata <- gimmedata(ExperimentName = 'FR',UniqueName = 'Implicit') %>%
#'       filter(`Screen Name` == 'response')
#'
#'}
#' @import dplyr stringr
#' @importFrom lubridate dmy_hms
#' @import readr
#' @export
#'
gimmedata <- function(DataDir = getwd(), ExperimentID = '[0-9]{5}', ExperimentName = '.*', UniqueName = '.*', Session = '.*', Run = '.*', clean = T, verbose = F) {

  p <- paste0('data_exp_([0-9]{5}-)*', ExperimentID, '(-[0-9]{5})*', '_', ExperimentName, '_Session', Session)
  d <- list.files(path = DataDir, pattern = p,full.names = T)
  if (verbose) {
    cat(paste0('Loading data from ', str_replace(d,DataDir,'')),sep = '\n')
    }

  p <- paste0('S',Session,'_', UniqueName, '_r',Run,'.csv')
  fs <- list.files(path = file.path(d),pattern = p,full.names = T)
  if (length(fs) == 0) { stop(paste0('Could not find data (', p, ')'))}

  d <- tibble()
  for (f in fs) {
    FF <- str_match_all(basename(f),'(S[^_]*)_([^_]*)_r([^\\.]*)')
    Session <- FF[[1]][2]
    UniqueName <- FF[[1]][3]
    Run <- FF[[1]][4]

    if (verbose) {cat(paste0('Loading ',str_replace(f,DataDir,'')),sep = '\n')}

    d <- read_csv(f,col_types = cols(.default = col_character())) %>%
      mutate(Session = as.character(Session),
             UniqueName = as.character(UniqueName),
             Run = as.character(Run)) %>%
      bind_rows(d,.)
  }
  if (clean){
    d <- d %>% select(-starts_with('order-'),-starts_with('checkpoint-'),-starts_with('branch-'),-`Schedule ID`,-starts_with('Participant'),`Participant Private ID`)
  }
  d %>% select(Session,UniqueName,Run,matches('PID'),everything()) %>%
    mutate(`UTC Date` = dmy_hms(`UTC Date`),
           `Local Date` = dmy_hms(`Local Date`))
  # %>%
  #   mutate_at(vars(one_of('Reaction Time', 'Attempt','X Coordinate','Y Coordinate')), as.numeric) %>%
  #   mutate_at(vars(one_of('Correct', 'Incorrect', 'Dishonnest')), as.logical)
}
