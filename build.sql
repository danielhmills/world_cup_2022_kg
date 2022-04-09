--Cleanup
SPARQL CLEAR GRAPH <urn:wc:2022:kg>;
SPARQL CLEAR GRAPH <urn:wc:2022:data>;

--Load Data
SPARQL LOAD <https://raw.githubusercontent.com/danielhmills/world_cup_2022_kg/master/data/world_cup_data.ttl> INTO <urn:wc:2022:data>;

--Forward Chaining
--Season
SPARQL
PREFIX : <https://raw.githubusercontent.com/danielhmills/world_cup_2022_kg/master/data/world_cup_data.ttl#>
PREFIX fifa: <http://www.openlinksw.com/ontology/fifa#>
INSERT INTO GRAPH <urn:wc:2022:kg>
    {
        ?seasonURI a fifa:Season;
        rdfs:label ?seasonName;
        fifa:hasCompetition ?competitionURI;
        fifa:hasMatch ?matchURI.

        ?competitionURI a fifa:Season;
        rdfs:label ?competitionName.
    }
FROM <urn:wc:2022:data>
WHERE 
    {
        :this1 :Results ?match.
        ?match 
            :IdSeason ?seasonID;
            :SeasonName/:Description ?seasonName;
            :SeasonShortName/:Description ?seasonShortName;
            :IdCompetition ?competitionID;
            :CompetitionName/:Description ?competitionName;
            :IdMatch ?matchID.
        BIND(URI(bif:sprintf('http://demo.openlinksw.com/fifa/wc2022/%s#season',?seasonID)) as ?seasonURI).
        BIND(URI(bif:sprintf('http://demo.openlinksw.com/fifa/wc2022/%s#match',?matchID)) as ?matchURI).
        BIND(URI(bif:sprintf('http://demo.openlinksw.com/fifa/wc2022/%s#competition',?competitionID)) as ?competitionURI)
    };

--Stage
SPARQL
PREFIX : <https://raw.githubusercontent.com/danielhmills/world_cup_2022_kg/master/data/world_cup_data.ttl#>
PREFIX fifa: <http://www.openlinksw.com/ontology/fifa#>

INSERT INTO GRAPH <urn:wc:2022:kg>
    {
        ?stageURI a fifa:Stage;
        rdfs:label ?stageName.

        ?matchURI fifa:hasStage ?stageURI.
    }
FROM <urn:wc:2022:data>
WHERE 
    {
        :this1 :Results ?match.
        ?match 
        :IdStage ?stageID;
        :StageName/:Description ?stageName;
        :IdMatch ?matchID.
        BIND(URI(bif:sprintf('http://demo.openlinksw.com/fifa/wc2022/%s#stage',?stageID)) as ?stageURI).
        BIND(URI(bif:sprintf('http://demo.openlinksw.com/fifa/wc2022/%s#match',?matchID)) as ?matchURI).
    };

--Group
SPARQL
PREFIX : <https://raw.githubusercontent.com/danielhmills/world_cup_2022_kg/master/data/world_cup_data.ttl#>
PREFIX fifa: <http://www.openlinksw.com/ontology/fifa#>

INSERT INTO GRAPH <urn:wc:2022:kg>
    {
        ?groupURI a fifa:Group;
        rdfs:label ?groupName.

        ?matchURI fifa:hasGroup ?groupURI.
    }
FROM <urn:wc:2022:data>
WHERE 
    {
        :this1 :Results ?match.
        ?match 
        :IdGroup ?groupID;
        :GroupName/:Description ?groupName;
        :IdMatch ?matchID.
        BIND(URI(bif:sprintf('http://demo.openlinksw.com/fifa/wc2022/%s#group',?groupID)) as ?groupURI).
        BIND(URI(bif:sprintf('http://demo.openlinksw.com/fifa/wc2022/%s#match',?matchID)) as ?matchURI).

    };

--Pending: Weather, Attendance, Matchday (Undreleased)

--Match ID
SPARQL
PREFIX : <https://raw.githubusercontent.com/danielhmills/world_cup_2022_kg/master/data/world_cup_data.ttl#>
PREFIX fifa: <http://www.openlinksw.com/ontology/fifa#>

INSERT INTO GRAPH <urn:wc:2022:kg>
    {
        ?matchURI a fifa:Match;
        rdfs:label ?title.
    }
FROM <urn:wc:2022:data>
WHERE 
    {
        :this1 :Results ?match.
        ?match 
        :IdMatch ?matchID.
        OPTIONAL{?match :GroupName/:Description ?groupName}.
        OPTIONAL{?match :StageName/:Description ?stageName}.
        OPTIONAL{?match :Home/:TeamName/:Description ?homeTeam}.
        OPTIONAL{?match :Away/:TeamName/:Description ?awayTeam}.
        BIND(bif:sprintf('%s: %s vs %s',IF(?groupName, ?groupName, ?stageName),IF(?homeTeam,?homeTeam,'Pending'),IF(?awayTeam,?awayTeam,"Pending") ) as ?title)
        BIND(URI(bif:sprintf('http://demo.openlinksw.com/fifa/wc2022/%s#match',?matchID)) as ?matchURI).

    };

--Dates
SPARQL
PREFIX : <https://raw.githubusercontent.com/danielhmills/world_cup_2022_kg/master/data/world_cup_data.ttl#>
PREFIX fifa: <http://www.openlinksw.com/ontology/fifa#>

INSERT INTO GRAPH <urn:wc:2022:kg>
    {
    ?matchURI fifa:date ?dateParse;
    fifa:localDate ?localDateParse.
    }
FROM <urn:wc:2022:data>
WHERE 
    {
        :this1 :Results ?match.
        ?match 
            :Date ?date;
            :LocalDate ?localDate;
            :IdMatch ?matchID.
        BIND(URI(bif:sprintf('http://demo.openlinksw.com/fifa/wc2022/%s#match',?matchID)) as ?matchURI).
        BIND(xsd:dateTime(?date) as ?dateParse).
        BIND(xsd:dateTime(?localDate) as ?localDateParse).

    };

--Match Number and Status
SPARQL
PREFIX : <https://raw.githubusercontent.com/danielhmills/world_cup_2022_kg/master/data/world_cup_data.ttl#>
PREFIX fifa: <http://www.openlinksw.com/ontology/fifa#>

INSERT INTO GRAPH <urn:wc:2022:kg>
    {
        ?matchURI fifa:hasMatchNumber ?matchNumberINT;
        fifa:hasMatchStatus ?matchStatus.
    }
FROM <urn:wc:2022:data>
WHERE 
    {
        :this1 :Results ?match.
        ?match 
        :MatchNumber ?matchNumber;
        :MatchStatus ?matchStatus;
        :IdMatch ?matchID.

        BIND(xsd:integer(?matchNumber) as ?matchNumberINT)
        BIND(URI(bif:sprintf('http://demo.openlinksw.com/fifa/wc2022/%s#match',?matchID)) as ?matchURI).

    };

--Stadium
SPARQL
PREFIX : <https://raw.githubusercontent.com/danielhmills/world_cup_2022_kg/master/data/world_cup_data.ttl#>
PREFIX fifa: <http://www.openlinksw.com/ontology/fifa#>

INSERT INTO GRAPH <urn:wc:2022:kg>
    {
        ?matchURI fifa:hasStadium ?stadiumURI.
    }
FROM <urn:wc:2022:data>
WHERE 
    {
        :this1 :Results ?match.
        ?match 
        :Stadium/:IdStadium ?stadiumID;
        :IdMatch ?matchID.
        BIND(URI(bif:sprintf('http://demo.openlinksw.com/fifa/wc2022/%s#stadium',?stadiumID)) as ?stadiumURI).
        BIND(URI(bif:sprintf('http://demo.openlinksw.com/fifa/wc2022/%s#match',?matchID)) as ?matchURI).
            
    };

--Stadium Details
SPARQL
PREFIX : <https://raw.githubusercontent.com/danielhmills/world_cup_2022_kg/master/data/world_cup_data.ttl#>
PREFIX fifa: <http://www.openlinksw.com/ontology/fifa#>

INSERT INTO GRAPH <urn:wc:2022:kg>
    {
        ?stadiumURI a fifa:Stadium;
        rdfs:label ?stadiumName;
        fifa:hasCity ?cityURI;
        fifa:hasCountry ?countryURI;
        fifa:hasRoof ?hasRoof.

        ?cityURI a fifa:City;
        fifa:hasCityID ?cityID;
        rdfs:label ?cityName.

        ?countryURI a fifa:Country;
        fifa:hasCountryID ?country;
        rdfs:label ?countryID.

    }
FROM <urn:wc:2022:data>
WHERE 
    {
        ?stadium
        :IdStadium ?stadiumID;
        :Name/:Description ?stadiumName;
        :IdCity ?cityID;
        :CityName/:Description ?cityName;
        :IdCountry ?stadiumCountry;
        :Roof ?hasRoof.
        BIND(URI(bif:sprintf('http://demo.openlinksw.com/fifa/wc2022/%s#stadium',?stadiumID)) as ?stadiumURI).
        BIND(URI(bif:sprintf('http://demo.openlinksw.com/fifa/wc2022/%s#city',?cityID)) as ?cityURI).
        BIND(URI(bif:sprintf('http://demo.openlinksw.com/fifa/wc2022/%s#country',?stadiumCountry)) as ?countryURI).
    };


--Home Team 
SPARQL
PREFIX : <https://raw.githubusercontent.com/danielhmills/world_cup_2022_kg/master/data/world_cup_data.ttl#>
PREFIX fifa: <http://www.openlinksw.com/ontology/fifa#>

INSERT INTO GRAPH <urn:wc:2022:kg>
    {
        ?matchURI fifa:hasHomeTeam ?teamURI.
    }

FROM <urn:wc:2022:data>
WHERE 
    {
        ?match
        :Home/:IdTeam ?homeTeam;
        :IdMatch ?matchID.
        BIND(URI(bif:sprintf('http://demo.openlinksw.com/fifa/wc2022/%s#match',?matchID)) as ?matchURI).
        BIND(URI(bif:sprintf('http://demo.openlinksw.com/fifa/wc2022/%s#team',?homeTeam)) as ?teamURI).

    };

--Away Team 
SPARQL
PREFIX : <https://raw.githubusercontent.com/danielhmills/world_cup_2022_kg/master/data/world_cup_data.ttl#>
PREFIX fifa: <http://www.openlinksw.com/ontology/fifa#>

INSERT INTO GRAPH <urn:wc:2022:kg>
    {
        ?matchURI fifa:hasAwayTeam ?teamURI.
    }
FROM <urn:wc:2022:data>
WHERE 
    {
        ?match
        :Away/:IdTeam ?awayTeam;
        :IdMatch ?matchID.
        BIND(URI(bif:sprintf('http://demo.openlinksw.com/fifa/wc2022/%s#match',?matchID)) as ?matchURI).
        BIND(URI(bif:sprintf('http://demo.openlinksw.com/fifa/wc2022/%s#team',?awayTeam)) as ?teamURI).

    };

--Team Details
SPARQL
PREFIX : <https://raw.githubusercontent.com/danielhmills/world_cup_2022_kg/master/data/world_cup_data.ttl#>
PREFIX fifa: <http://www.openlinksw.com/ontology/fifa#>
INSERT INTO GRAPH <urn:wc:2022:kg>
    {
        ?teamURI a fifa:Team;
        rdfs:label ?teamName;
        fifa:hasTeamID ?teamID;
        fifa:hasAssociation ?associationURI;
        fifa:hasShortName ?shortName;
        fifa:hasCountry ?countryURI;
        fifa:hasGender ?gender.
        #Images Pending.

        ?associationURI a fifa:Association;
        fifa:hasAssociationID ?associationID.

        ?countryURI a fifa:Country;
        rdfs:label ?teamName;
        fifa:hasCountryID ?countryID.
    }
FROM <urn:wc:2022:data>
WHERE 
    {
        ?team
        :IdTeam ?teamID;
        :TeamName/:Description ?teamName;
        :IdAssociation ?associationID;
        :TeamType ?teamType;
        :Abbreviation ?shortName;
        :IdCountry ?countryID;
        :AgeType ?ageType;
        :FootballType ?footballType;
        :Gender ?gender;
        :PictureUrl ?image.
        BIND(URI(bif:sprintf('http://demo.openlinksw.com/fifa/wc2022/%s#team',?teamID)) as ?teamURI).
        BIND(URI(bif:sprintf('http://demo.openlinksw.com/fifa/wc2022/%s#association',?associationID)) as ?associationURI).
        BIND(URI(bif:sprintf('http://demo.openlinksw.com/fifa/wc2022/%s#country',?countryID)) as ?countryURI).
    };