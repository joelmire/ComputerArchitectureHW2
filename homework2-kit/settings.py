# ======= GENERAL SETTINGS: Adapt these per assignment =============
ASSIGNMENT = "Duke ECE/CS 250 Homework 2"
SEMESTER = "Spring 2018"
TEST_DIR = 'tests' # where test files are located
IS_GRADER = True # if true, we'll expect to see a 'points' parameter in test setup

SPIM_BINARY = 'spim' # location of spim executable (or just 'spim' if in path); only needed if mode is SPIM
LOGISIM_JAR = 'logisim_cli.jar' # location of logisim_cli.jar; only needed if mode is LOGISIM

# modes: 
#   EXECUTABLE - for C programs, etc.
#   SPIM       - run with command line spim
#   LOGISIM    - run with logisim command-line front-end
MODE = 'SPIM'

NON_ZERO_EXIT_STATUS_PENALTY = 0.75 # multiply score by this if exit status is non-zero
VALGRIND_PENALTY = 0.5 # multiply score by this if a valgrind test showed a leak

# ============= TEST SETUP ========================
suite_names = ('bythree', 'recurse', 'PlayerStats' )
suites = {
    "bythree": [
        { "desc": "n = 1",  "infile": 'bythree_input_0.txt', "preprocess_actual":spim_clean },
        { "desc": "n = 2",  "infile": 'bythree_input_1.txt',  "preprocess_actual":spim_clean},
        { "desc": "n = 3",  "infile": 'bythree_input_2.txt',  "preprocess_actual":spim_clean},
        { "desc": "n = 4",  "infile": 'bythree_input_3.txt',  "preprocess_actual":spim_clean },
    ],
    "recurse": [
        { "desc": "n = 1",  "infile": 'recurse_input_0.txt',   "preprocess_actual":spim_clean},
        { "desc": "n = 2",  "infile": 'recurse_input_1.txt',  "preprocess_actual":spim_clean},
        { "desc": "n = 3",  "infile": 'recurse_input_2.txt',   "preprocess_actual":spim_clean},
        { "desc": "n = 4",  "infile": 'recurse_input_3.txt',   "preprocess_actual":spim_clean },
    ],
    "PlayerStats": [
        { "desc": "One Player",                      "infile": 'PlayerStats_input_0.txt', 'diff': hoopstat_diff, "preprocess_actual":spim_clean },
        { "desc": "Two players with same stats",          "infile": 'PlayerStats_input_1.txt', 'diff': hoopstat_diff, "preprocess_actual":spim_clean },
        { "desc": "Two players with different stats",      "infile": 'PlayerStats_input_2.txt', 'diff': hoopstat_diff, "preprocess_actual":spim_clean },
        { "desc": "Ten players",                    "infile": 'PlayerStats_input_3.txt', 'diff': hoopstat_diff, "preprocess_actual":spim_clean},
        { "desc": "Don't print after DONE",        "infile": 'PlayerStats_input_4.txt', 'diff': hoopstat_diff, "preprocess_actual":spim_clean},
        { "desc": "Correct output with play minutes equal to zero",   "infile": 'PlayerStats_input_5.txt',"preprocess_actual":spim_clean, "preprocess_actual":spim_clean },
        { "desc": "Correct output with both points and assistances equal to zero",       "infile": 'PlayerStats_input_6.txt', 'diff': hoopstat_diff, "preprocess_actual":spim_clean },
        { "desc": "100 players, some stats are zero",                    "infile": 'PlayerStats_input_7.txt', 'diff': hoopstat_diff, "preprocess_actual":spim_clean},
    ]    
}
