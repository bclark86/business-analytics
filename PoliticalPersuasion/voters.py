import pandas as pd
import pandas_profiling as pp

def read_voters(file, report=True):
    # read in data using pandas
    voters = pd.read_csv(file)

    # create variable summary report
    if report:
        profile = pp.ProfileReport(voters)
        profile.to_file("VotersSummary.html")
    
    return voters
