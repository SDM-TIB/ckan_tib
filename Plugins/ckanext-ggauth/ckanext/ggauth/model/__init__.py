# encoding: utf-8
import logging
import uuid
import enum

from ckan import model
import ckan.model.meta as meta
from sqlalchemy import Column, MetaData, ForeignKey, types
from sqlalchemy.orm import relationship
from sqlalchemy.ext.declarative import declarative_base

metadata = meta.metadata
# metadata = MetaData()
Base = declarative_base()

log = logging.getLogger(__name__)


def make_uuid():
    return unicode(uuid.uuid4())


class StatusClass(enum.Enum):
    NONE = "None"
    PENDING = "Pending"
    APPROVED = "Approved"
    DENIED = "Denied"

    @classmethod
    def list(cls):
        return [enum.value for enum in cls]

    @classmethod
    def selectbox(cls):
        return [{'name': enum.value, 'value': enum.value} for enum in cls]


StatusType = types.Enum(*StatusClass.list(), name="status_type")


class Authorization(Base):
    '''
        Details of the archival of resources. Has the filepath for successfully
        archived resources. Basic error history provided for unsuccessful ones.
    '''
    __tablename__ = 'authorization'

    id = Column(types.UnicodeText, primary_key=True, default=make_uuid)

    resource_id = Column(
        types.UnicodeText,
        ForeignKey(model.Resource.id), nullable=False, index=True)
    group_id = Column(
        types.UnicodeText, ForeignKey(model.Group.id), unique=False)

    download = Column(StatusType, unique=False, default=StatusClass.NONE.value)
    preview = Column(StatusType, unique=False, default=StatusClass.NONE.value)
    schema = Column(StatusType, unique=False, default=StatusClass.NONE.value)

    group = relationship(model.Group, cascade="all, delete-orphan",
                         single_parent=True)
    resource = relationship(model.Resource, backref="authorization",
                            cascade="all, delete-orphan", single_parent=True)

    def __repr__(self):
        return "<Permission(resource_id='%s', group_id='%s', download='%s', preview='%s', schema='%s')>" % \
            (self.resource_id, self.group_id, self.download,
                self.preview, self.schema)


def init_tables(engine):
    '''
        Will not try to recreate if they already exist
    '''
    Base.metadata.create_all(engine)
    log.info('auth database tables are set-up')


def destroy_tables(engine):
    model.meta.Session.close_all()
    Authorization.__table__.drop(engine)
    log.info('auth database tables are dropped')
