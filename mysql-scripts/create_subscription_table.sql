create table if not exists subscription
(
    user_id         bigint                              not null
        primary key,
    product_a  varchar(100)                        not null,
    product_b  varchar(100)                        not null,
    created_at timestamp default CURRENT_TIMESTAMP not null,
    updated_at timestamp default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP
);

