from flask import Flask, request, jsonify
import random
import json

CREDIT_HOURS_LIMIT = 18
POPULATION_SIZE = 10
MAX_GENERATIONS = 100


class Course:
    def __init__(self, code, title, credit_hours, prerequisites=None):
        self.code = code
        self.title = title
        self.credit_hours = credit_hours
        self.prerequisites = set() if prerequisites is None else set(prerequisites)


curriculum = {
    1: {
        "sc1201": Course("sc1201", "Applied Physics", "3", ""),
        "sc1001": Course("sc1001", "Calculus & Analytic Geometry", "3", ""),
        "hu1002": Course("hu1002", "English Composition & Comprehension", "3", ""),
        "cs1501": Course(
            "cs1501",
            "Introduction to Information and Communication Technologies",
            "2",
            "",
        ),
        "cs1001": Course("cs1001", "Programming Fundamentals", "4", " "),
    },
    2: {
        "hu1003": Course("hu1003", "Communication & Presentation Skills", "3", ""),
        "cs1502": Course("cs1502", "Digital Logic and Design", "4", ""),
        "hu1101": Course("hu1101", "Islamic Studies", "2", ""),
        "sc1002": Course("sc1002", "Multivariate Calculus", "2", "sc1001"),
        "cs2301": Course("cs2301", "Discrete Structures", "2", ""),
        "cs1002": Course("cs1002", "Programming Techniques", "2", "cs1001"),
    },
    3: {
        "cs2503": Course(
            "cs2503", "Computer Organization & Assembly Language", "4", ""
        ),
        "cs2003": Course("cs2003", "Data Structure and Algorithms", "4", "cs1001"),
        "sc2003": Course("sc2003", "Differential Equations", "3", "sc1001"),
        "hu1102": Course("hu1102", "Pakistan Studies", "2", ""),
        "cs2004": Course("cs2004", "Object Oriented Programming", "4", "cs1001"),
    },
    4: {
        "cs2201": Course("cs2201", "Introduction to Database Systems", "4", "cs2003"),
        "cs2504": Course("cs2504", "Operating Systems", "4", "cs2003"),
        "sc2004": Course("sc2004", "Probability and Statistics", "3", ""),
        "cs2101": Course("cs2101", "Software Engineering", "3", ""),
    },
    5: {
        "cs4303": Course("cs4303", "Artificial Intelligence", "4", "cs2003"),
        "cs3005": Course("cs3005", "Design & Analysis of Algorithms", "3", "cs2003"),
        "cs3202": Course("cs3202", "Web Engineering", "4", "cs2003"),
        "cs3002": Course("cs3002", "Computer Networks", "3", "cs2003"),
        "cs3003": Course("cs3003", "Software Project Management", "3", "cs2101"),
    },
    6: {
        "cs3701": Course("cs3701", "Computer Graphics", "4", "cs2004"),
        "cs4102": Course("cs4102", "Software Project-I", "4", "cs2004"),
        "cs3702": Course("cs3702", "Theory of Automata", "3", "cs2004"),
        "cs4001": Course("cs4001", "Digital Image Processing", "3", "cs2004"),
        "cs4602": Course("cs4602", "Data Warehousing & Data Mining", "3", "cs2201"),
    },
    7: {
        "cs4701": Course("cs4701", "Introduction to Machine Learning", "3", "CS3005"),
        "cs4802": Course("cs4802", "Software Project-II", "3", "cs4102"),
        "cs4201": Course("cs4201", "Advanced Database Systems", "3", "cs2201"),
        "cs4302": Course("cs4302", "Software Quality Assurance", "3", "cs3003"),
        "cs4503": Course("cs4503", "Compiler Construction", "3", "cs3702"),
        "cs4004": Course("cs4004", "Parallel Computing", "3", "cs3002"),
    },
    8: {
        "cs4801": Course("cs4801", "Final Year Project", "4", ""),
        "cs4902": Course("cs4902", "Software Project-III", "4", "cs4802"),
        "cs4502": Course("cs4502", "Advanced Operating Systems", "4", "cs2504"),
        "cs4603": Course("cs4603", "Human Computer Interaction", "3", ""),
        "cs4005": Course("cs4005", "Wireless Networks", "3", "cs3002"),
    },
}


def crossover(parent1, parent2):
    # Select a random crossover point
    crossover_point = random.randint(1, min(len(parent1), len(parent2)))

    # Perform crossover
    offspring1 = parent1[:crossover_point] + parent2[crossover_point:]
    offspring2 = parent2[:crossover_point] + parent1[crossover_point:]

    return offspring1, offspring2


def mutate(chromosome):
    mutated_chromosome = chromosome

    # let us mutate by swapping two random courses
    mutation_point1 = random.randint(0, len(chromosome) - 1)
    mutation_point2 = random.randint(0, len(chromosome) - 1)

    mutated_chromosome[mutation_point1], mutated_chromosome[mutation_point2] = (
        mutated_chromosome[mutation_point2],
        mutated_chromosome[mutation_point1],
    )

    return mutated_chromosome


def generate_chromosome(current_semester, failed_courses):
    chromosome = []

    # completed courses
    completed_courses = []
    for i in range(1, current_semester):
        completed_courses.extend(curriculum[i].keys())

    # failed courses are not considered as completed courses
    for course in failed_courses:
        if course in completed_courses:
            completed_courses.remove(course)

    # courses that can be taken in current semester
    courses = []
    for course in curriculum[current_semester].values():
        if course.code not in completed_courses:
            # now checking if the prerequisites of the course are completed
            if course != "" and course.prerequisites.issubset(completed_courses):
                courses.append(course)

    # now adding failed courses to the list of courses
    for course in failed_courses:
        for semester in range(1, current_semester):
            if course in curriculum[semester].keys():
                courses.append(curriculum[semester][course])

    # now to check if the credit hours limit is exceeded
    credit_hours = 0
    for course in courses:
        credit_hours += int(course.credit_hours)

    if credit_hours > CREDIT_HOURS_LIMIT:
        random.shuffle(courses)
        courses.pop()

    # now making the courses into a chromosome

    chromosome = courses
    return chromosome


def calculate_fitness(chromosome):
    fitness = 0

    for course in chromosome:
        fitness += int(course.credit_hours)

    return fitness


def genetic_algorithm(current_semester, failed_courses):
    population = []

    # generate initial population
    for i in range(POPULATION_SIZE):
        population.append(generate_chromosome(current_semester, failed_courses))

    # now to run the genetic algorithm
    for generation in range(MAX_GENERATIONS):
        # calculate fitness of each chromosome
        fitness = []
        for chromosome in population:
            fitness.append(calculate_fitness(chromosome))

        # now to select the parents
        parents = []
        for i in range(2):
            max_fitness_index = fitness.index(max(fitness))
            parents.append(population[max_fitness_index])
            fitness.pop(max_fitness_index)
            population.pop(max_fitness_index)

        # now to perform crossover
        offspring = crossover(parents[0], parents[1])

        # now to add the offspring to the population
        population.extend(offspring)

        # now to select the best chromosomes
        fitness = []
        for chromosome in population:
            fitness.append(calculate_fitness(chromosome))

        # now to select the best chromosomes
        best_chromosomes = []
        for i in range(2):
            max_fitness_index = fitness.index(max(fitness))
            best_chromosomes.append(population[max_fitness_index])
            fitness.pop(max_fitness_index)
            population.pop(max_fitness_index)

        # now to add the best chromosomes to the population
        population.extend(best_chromosomes)

    # now to select the best chromosome
    fitness = []
    for chromosome in population:
        fitness.append(calculate_fitness(chromosome))

    max_fitness_index = fitness.index(max(fitness))
    best_chromosome = population[max_fitness_index]

    return best_chromosome


app = Flask(__name__)


@app.route("/courses", methods=["POST"])
def get_courses():
    data = request.get_json()  # Get the JSON data from the request
    current_semester = int(data["current_semester"])
    failed_courses = data["failed_courses"].split(" ")

    # Run the genetic algorithm
    courses = genetic_algorithm(current_semester, failed_courses)

    # Generate the JSON response
    response_data = {
        "current_semester": current_semester,
        "courses": [
            {
                "code": course.code,
            }
            for course in courses
        ],
    }

    return jsonify(response_data)  # Return the JSON response


if __name__ == "__main__":
    app.run()
