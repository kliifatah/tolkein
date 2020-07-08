#!/usr/bin/env python3
"""Test functions in tobin."""

import logging
import pytest

from tolkein import tolog


def test_logger_config_default():
    """Test logger_config default return values."""
    config = tolog.logger_config()
    assert isinstance(config, dict)
    assert 'level' in config
    assert 'format' in config
    assert 'filemode' in config
    assert config['level'] == logging.INFO


def test_logger_config_debug():
    """Test logger_config debug return values."""
    config = tolog.logger_config(debug=True)
    assert isinstance(config, dict)
    assert 'level' in config
    assert 'format' in config
    assert 'filemode' in config
    assert config['level'] == logging.DEBUG


@pytest.fixture(scope='function', name='_my_logger')
def my_logger():
    """Return logger instance."""
    return tolog.logger()


@pytest.fixture(scope='function', name='_debug_logger')
def debug_logger():
    """Return logger instance."""
    return tolog.logger('debug', True)


def test_logger(_my_logger, _debug_logger):
    """Test logger function returns valid loggers."""
    assert isinstance(_my_logger, logging.Logger)
    assert _my_logger.name == 'tolkein'
    assert _my_logger.level == logging.INFO
    assert isinstance(_debug_logger, logging.Logger)
    assert _debug_logger.name == 'debug'
    assert _debug_logger.level == logging.DEBUG


def test_logger_output(_my_logger, _debug_logger, caplog):
    """Test logger function output."""
    _my_logger.info('message 1')
    _debug_logger.info('message 2')
    _my_logger.debug('no message 3')
    _debug_logger.debug('message 4')
    assert 'message 1' in caplog.text
    assert 'message 2' in caplog.text
    assert 'message 3' not in caplog.text
    assert 'message 4' in caplog.text


def test_DisableLogger(_my_logger, caplog):
    with tolog.DisableLogger():
        _my_logger.info('message 1')
        _my_logger.error('message 2')
        _my_logger.critical('message 3')
    _my_logger.info('message 4')
    assert 'message 1' not in caplog.text
    assert 'message 2' not in caplog.text
    assert 'message 3' not in caplog.text
    assert 'message 4' in caplog.text