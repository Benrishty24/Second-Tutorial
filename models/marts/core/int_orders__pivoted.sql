{%- set paymentmethods = ['bank_transfer', 'coupon', 'credit_card', 'gift_card'] -%}

with payments as (
    select * from dbt-tutorial.stripe.payment
),
pivoted as (
    select
        orderid,
        {% for paymentmethod in paymentmethods -%}

        sum(case when paymentmethod = '{{paymentmethod}}' then amount else 0 end) as {{paymentmethod}}_amount
        {%- if not loop.last -%}
        ,
        {%- endif %}   
        {% endfor -%}
    from payments
    where status = 'success'
    group by 1
)
select * from pivoted
