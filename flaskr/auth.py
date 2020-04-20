import functools

from flask import (
    Blueprint, g, redirect, render_template, request, session, url_for, Response
)
from werkzeug.security import check_password_hash, generate_password_hash
from flaskr.db import get_db

bp = Blueprint('auth', __name__, url_prefix='/account')


@bp.route('/account', methods=['POST'])
def account_create():
    acc_type = request.form['acc_type']
    name = request.form['name']
    email = request.form['email']
    logo = request.form['logo']
    telephone = request.form['telephone']
    password = request.form['password']

    db = get_db
    error = None

    if not acc_type:
        error = 'Account needs a type'
    elif not password:
        error = 'Account needs password'
    elif not name:
        error = 'Account needs name'
    elif not email:
        error = 'Account needs email'
    elif db.execute('SELECT id FROM account WHERE email = ?', (email,)).fetchone() is not None:
        error = 'Account {} is already registered with that email'.format(
            email)
    elif db.execute('SELECT id FROM account WHERE telephone = ?', (telephone,)).fetchone() is not None:
        error = 'Account {} is already registered with that telephone'.format(
            telephone)

    if error is None:
        db.execute('INSERT INTO account (acc_type, name, email, logo, telephone, password)',
                   (acc_type, name, email, logo, telephone, generate_password_hash(password)))
        db.commit()

        # get id of that account, create a token with expiry date and account id
        account = db.execute(
            'SELECT * FROM account WHERE email = ?', (email,)
        ).fetchone()

        minsexpire = 60

        db.execute('INSERT INTO token (account_id, minsexpire)',
                   (account['id'], minsexpire))
        db.commit()

        session.clear()
        session['account_id'] = account['id']
        # send success message
        status = Response(status=201)

        return status

    # send error message
    status = Response(status=201)
    status.set_data(error)
    return status
