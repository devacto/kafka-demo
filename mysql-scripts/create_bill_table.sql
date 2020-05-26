create table if not exists bill
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