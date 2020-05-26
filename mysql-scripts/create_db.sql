CREATE DATABASE telco;

USE telco;

CREATE TABLE IF NOT EXISTS bill
(
    user_id            bigint                              not null primary key,
    status             varchar(10)                         not null,
    age                int                                 null,
    data_usage_bytes   bigint                              not null,
    voice_usage_secs   bigint                              null,
    total              float                               null,
    sms                int                                 null,
    data_roaming_bytes bigint                              not null,
    created_at         timestamp default CURRENT_TIMESTAMP not null,
    updated_at         timestamp default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS subscription
(
    user_id         bigint                              not null
        primary key,
    product_a  varchar(100)                        not null,
    product_b  varchar(100)                        not null,
    created_at timestamp default CURRENT_TIMESTAMP not null,
    updated_at timestamp default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP
);