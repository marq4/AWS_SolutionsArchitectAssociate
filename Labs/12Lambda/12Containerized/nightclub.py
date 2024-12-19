""" Greet user IF they're allowed into the nightclub. """

def age_is_valid(age: int) -> bool:
    """ Returns whether age is in right range. """
    return False if not (21 <= age <= 48) else True
#

def get_guest_title(gender: str) -> str:
    """ Return title based on gender. """
    title = 'Guest'
    if gender == 'f':
        title = 'Madam'
    elif gender == 'm':
        title = 'Sir'
    return title
#

def main(age: int, gender: str):
    """ Return greeting to user based on user's age and gender. """
    if not age_is_valid(age):
        return "Either too old or not enough to party. Go home. "
    title = get_guest_title(gender)
    return f"Welcome to the club, {title}. "
#

def function(event, context):
    """ Call main and pass args. """
    result = main(int(event['age']), event['gender'])
    return result
#
