
-- Create user table on schema eugene on Azure SQL Server Database
CREATE TABLE eugene.user
(
    id                  BIGINT IDENTITY (1,1) PRIMARY KEY,
    user_id           NVARCHAR(64) NOT NULL,
    user_name         NVARCHAR(64) NOT NULL,
    city                NVARCHAR(64),
    type                SMALLINT CHECK (type IN (0, 1, 2)),
    status              SMALLINT     NOT NULL DEFAULT 0 CHECK (status IN (0, 1, 2)),
    open_id             NVARCHAR(64),
    is_deleted          SMALLINT     NOT NULL DEFAULT 0 CHECK (is_deleted IN (0, 1)),
    create_time         DATETIME2    NOT NULL DEFAULT SYSDATETIME(),
    create_by           NVARCHAR(64),
    phone_number        NVARCHAR(32),
    area                NVARCHAR(64),
    code                NVARCHAR(64),
    account_city        NVARCHAR(64),
    company             NVARCHAR(64),
    account_number      NVARCHAR(64),
    user_email        NVARCHAR(320),
    login_status        SMALLINT     NOT NULL DEFAULT 0 CHECK (login_status IN (0, 1)),
    update_time         DATETIME2    NOT NULL DEFAULT SYSDATETIME(),
    update_by           NVARCHAR(64),
    updater_email       NVARCHAR(320),
);

-- Unique constraint & index
ALTER TABLE eugene.user
    ADD CONSTRAINT uq_user_phone_number UNIQUE (phone_number);
CREATE INDEX idx_user_phone_number ON eugene.user (phone_number);

-- Create user_verification_code table
CREATE TABLE eugene.user_verification_code
(
    id           BIGINT IDENTITY (1,1) PRIMARY KEY,
    user_id    BIGINT        NOT NULL FOREIGN KEY REFERENCES eugene.user (id) ON DELETE CASCADE,
    phone_number NVARCHAR(32)  NOT NULL,
    content      NVARCHAR(256) NOT NULL,
    expire_time  DATETIME2     NOT NULL,
    create_time  DATETIME2     NOT NULL DEFAULT SYSDATETIME(),
    create_by    NVARCHAR(64),
    status       SMALLINT      NOT NULL DEFAULT 0 CHECK (status IN (0, 1, 2))
);

CREATE INDEX idx_verification_phone_number
    ON eugene.user_verification_code (phone_number);
